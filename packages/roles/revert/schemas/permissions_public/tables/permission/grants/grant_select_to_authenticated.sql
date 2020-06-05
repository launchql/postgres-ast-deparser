-- Revert schemas/permissions_public/tables/permission/grants/grant_select_to_authenticated from pg

BEGIN;

REVOKE SELECT ON TABLE permissions_public.permission FROM authenticated;

COMMIT;
