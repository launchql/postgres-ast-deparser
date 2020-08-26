-- Revert schemas/status_public/tables/user_task/grants/grant_select_to_authenticated from pg

BEGIN;

REVOKE SELECT ON TABLE status_public.user_task FROM authenticated;

COMMIT;
