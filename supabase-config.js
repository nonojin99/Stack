// ===== Supabase 온라인 랭킹 설정 =====
//
// 1. https://supabase.com 에서 무료 프로젝트를 만듭니다.
// 2. Supabase 대시보드 > SQL Editor 에서 supabase/schema.sql 내용을 실행합니다.
// 3. 대시보드 > Settings > API 에서 아래 두 값을 복사해 채웁니다.
//    - url:     Project URL       (예: "https://abcdefgh.supabase.co")
//    - anonKey: anon public key   (publishable key — 클라이언트 공개용 키)
//
// 값을 비워 두면 온라인 랭킹 없이 브라우저(localStorage) 랭킹으로만 동작합니다.
window.SUPABASE_CONFIG = {
  url: "",
  anonKey: "",
};
