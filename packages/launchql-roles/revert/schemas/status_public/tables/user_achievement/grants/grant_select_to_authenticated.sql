-- Revert schemas/status_public/tables/user_achievement/grants/grant_select_to_authenticated from pg

BEGIN;

REVOKE SELECT ON TABLE status_public.user_achievement FROM authenticated;

COMMIT;
