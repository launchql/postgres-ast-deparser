-- Revert: schemas/launchql_private/tables/user_secrets/table from pg

BEGIN;
DROP TABLE "launchql_rls_private".user_secrets;
COMMIT;  

