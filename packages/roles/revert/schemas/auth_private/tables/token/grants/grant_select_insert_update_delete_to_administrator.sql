-- Revert schemas/auth_private/tables/token/grants/grant_select_insert_update_delete_to_administrator from pg

BEGIN;

REVOKE SELECT,INSERT,UPDATE,DELETE ON TABLE auth_private.token FROM administrator;

COMMIT;
