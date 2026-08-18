# STACK! - 박스 쌓기 미니게임

번갈아 날아오는 박스를 클릭으로 떨어뜨려 최대한 높이 쌓아 올리는 HTML5 캔버스 미니게임입니다.

- `index.html` — **3D 모드** (아이소메트릭, X/Z 두 축으로 번갈아 이동)
- `2d.html` — 2D 클래식 모드 (좌/우로 이동)

두 모드 모두 외부 라이브러리 없이 캔버스만으로 렌더링합니다.

## 게임 방법

1. **게임 시작**을 누르면 두 방향에서 박스가 번갈아 날아옵니다.
2. 화면을 **클릭(터치)** 하거나 **스페이스바**를 누르면 박스가 떨어집니다.
3. 아래 박스와 **겹친 부분(교집합)만큼만** 쌓이고, 삐져나온 부분은 잘려서 떨어집니다.
4. 다음 박스는 방금 쌓인 **교집합 크기**로 생성됩니다.
5. 클릭했을 때 아래 박스와 **전혀 겹치지 않으면 게임 오버**입니다.
6. 정확히 맞추면 **PERFECT!** — 박스가 잘리지 않고 그대로 유지됩니다.

## 점수 & 랭킹

- 점수는 쌓아 올린 층수입니다.
- 게임 오버 시 이름을 입력해 랭킹에 등록할 수 있습니다.
- 기본값은 브라우저 `localStorage` 저장(TOP 10)이며, Supabase를 연동하면 **모든 사용자가 공유하는 온라인 랭킹**으로 동작합니다.

## Supabase 온라인 랭킹 연동 (선택)

1. [supabase.com](https://supabase.com)에서 무료 프로젝트를 만듭니다.
2. 대시보드 **SQL Editor**에서 [`supabase/schema.sql`](supabase/schema.sql) 내용을 붙여넣고 실행합니다.
   - `rankings` 테이블이 생성되고, 누구나 조회/점수 등록만 가능하도록 RLS 정책이 설정됩니다 (수정·삭제 불가).
3. 대시보드 **Settings > API**에서 두 값을 복사해 [`supabase-config.js`](supabase-config.js)에 채웁니다.

   ```js
   window.SUPABASE_CONFIG = {
     url: "https://abcdefgh.supabase.co",  // Project URL
     anonKey: "eyJhbGciOi...",             // anon public key
   };
   ```

4. 배포하면 끝입니다. 랭킹 화면에 `🌐 온라인 전체 랭킹`으로 표시됩니다.

동작 방식:

- 별도 SDK 없이 Supabase REST API(PostgREST)를 `fetch`로 직접 호출합니다.
- `anon` 키는 클라이언트 공개용 키이며, 서버 측 RLS 정책과 값 제약(이름 최대 10자, 점수 범위, 모드 값)으로 보호됩니다.
- 설정이 비어 있거나 서버 연결에 실패하면 자동으로 로컬(localStorage) 랭킹으로 폴백합니다.
- 3D와 2D 모드는 `mode` 컬럼으로 구분되어 각각 따로 집계됩니다.

## 실행

별도 빌드 없이 `index.html`을 브라우저에서 열면 바로 실행됩니다.

```bash
# 로컬 서버로 실행하는 경우
python3 -m http.server 8000
# http://localhost:8000 접속
```

GitHub Pages 등 정적 호스팅에 그대로 배포할 수 있습니다.
