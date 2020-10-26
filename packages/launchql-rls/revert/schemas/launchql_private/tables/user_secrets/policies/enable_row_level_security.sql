-- Revert: schemas/launchql_private/tables/user_secrets/policies/enable_row_level_security from pg

BEGIN;


ALTER TABLE "launchql_rls_private".user_secrets
    DISABLE ROW LEVEL SECURITY;

COMMIT;  

