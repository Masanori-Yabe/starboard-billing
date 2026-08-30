-- ─────────────────────────────────────────────────────────────
-- billing_deals に「経路」を足す（2026-08-30）
--
-- なぜ請求システム側なのか:
--   HUB にも同じ意味の欄（candidates.entry_org_type / entry_org_name）が
--   前からあるが、213名中 0名しか埋まっていない。人材の登録画面にしか
--   無く、LPK を知っている人がその画面を開かないため。
--   内定を登録するのはこの画面なので、ここに置けば埋まる。
--
-- 何に使うか:
--   HUB の入国サポートが読む。LPK 経由ならフライトチケットの手配を LPK に
--   依頼し、そうでなければ本人に取らせる。**手配の相手が変わる。**
--
-- 安全性: 列を2つ足すだけ。既存の行は NULL になり、画面も動作も変わらない。
--         既存データは一切書き換えない。
-- ─────────────────────────────────────────────────────────────
ALTER TABLE billing_deals ADD COLUMN IF NOT EXISTS route_type text;
ALTER TABLE billing_deals ADD COLUMN IF NOT EXISTS route_name text;

COMMENT ON COLUMN billing_deals.route_type IS 'LPK / 個人紹介 / 直接';
COMMENT ON COLUMN billing_deals.route_name IS '送り出し機関名または紹介者名。表記ゆれを避けるため画面は候補から選ばせる';

-- 確認用（実行後に流すと、2列が増えたことが見えます）
-- SELECT column_name, data_type FROM information_schema.columns
--  WHERE table_name = 'billing_deals' AND column_name LIKE 'route%';
