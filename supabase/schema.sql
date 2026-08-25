-- STACK! 게임 온라인 랭킹 테이블
-- Supabase 대시보드 > SQL Editor 에서 이 파일 전체를 실행하세요.
-- (이미 이전 버전을 실행한 프로젝트에서 다시 실행해도 안전합니다)

create table if not exists public.rankings (
  id         uuid primary key default gen_random_uuid(),
  name       text not null check (char_length(name) between 1 and 10),
  score      integer not null check (score >= 0 and score <= 100000),
  mode       text not null check (mode in ('3d', '2d')),
  created_at timestamptz not null default now()
);

-- 랭킹 조회용 인덱스
create index if not exists rankings_mode_score_idx
  on public.rankings (mode, score desc, created_at asc);

-- 같은 (mode, name)의 기존 중복 기록은 최고점 한 건만 남기고 정리
delete from public.rankings r
using (
  select id, row_number() over (
    partition by mode, name
    order by score desc, created_at asc, id
  ) as rn
  from public.rankings
) d
where r.id = d.id and d.rn > 1;

-- 아이디(이름)당 모드별 한 건만 허용
alter table public.rankings
  drop constraint if exists rankings_mode_name_key;
alter table public.rankings
  add constraint rankings_mode_name_key unique (mode, name);

-- 점수 등록 함수: 기존 점수보다 높을 때만 기록/갱신
create or replace function public.submit_score(p_name text, p_score integer, p_mode text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.rankings (name, score, mode)
  values (p_name, p_score, p_mode)
  on conflict (mode, name) do update
    set score = excluded.score,
        created_at = now()
    where rankings.score < excluded.score;
end;
$$;

revoke all on function public.submit_score(text, integer, text) from public;
grant execute on function public.submit_score(text, integer, text) to anon, authenticated;

-- RLS: 누구나 읽기 가능, 등록은 submit_score 함수로만 (직접 insert/update/delete 불가)
alter table public.rankings enable row level security;

drop policy if exists "anyone can read rankings" on public.rankings;
create policy "anyone can read rankings"
  on public.rankings for select
  using (true);

drop policy if exists "anyone can submit score" on public.rankings;
