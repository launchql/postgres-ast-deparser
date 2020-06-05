-- Revert schemas/permissions_private/tables/profile_permissions/grants/grant_select_insert_delete_to_authenticated from pg

BEGIN;

REVOKE SELECT, INSERT, DELETE ON TABLE permissions_private.profile_permissions FROM authenticated;

COMMIT;
