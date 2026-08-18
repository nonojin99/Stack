-- STACK! 게임 온라인 랭킹 테이블
-- Supabase 대시보드 > SQL Editor 에서 이 파일 전체를 실행하세요.

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

-- RLS: 누구나 읽기/점수 등록만 가능, 수정/삭제는 불가
alter table public.rankings enable row level security;

drop policy if exists "anyone can read rankings" on public.rankings;
create policy "anyone can read rankings"
  on public.rankings for select
  using (true);

drop policy if exists "anyone can submit score" on public.rankings;
create policy "anyone can submit score"
  on public.rankings for insert
  with check (true);
