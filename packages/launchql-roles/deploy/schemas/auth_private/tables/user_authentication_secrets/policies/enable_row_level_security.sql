-- Deploy schemas/auth_private/tables/user_authentication_secrets/policies/enable_row_level_security to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/tables/user_authentication_secrets/table

BEGIN;

ALTER TABLE auth_private.user_authentication_secrets
    ENABLE ROW LEVEL SECURITY;

COMMIT;
