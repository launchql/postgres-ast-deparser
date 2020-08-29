-- Deploy schemas/auth_private/tables/token/grants/grant_select_insert_update_delete_to_administrator to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/tables/token/table

BEGIN;

GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE auth_private.token TO administrator;

COMMIT;
