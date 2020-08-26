-- Deploy schemas/roles_private/tables/user_secrets/policies/enable_row_level_security to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_private/tables/user_secrets/table

BEGIN;

ALTER TABLE roles_private.user_secrets
    ENABLE ROW LEVEL SECURITY;

COMMIT;
