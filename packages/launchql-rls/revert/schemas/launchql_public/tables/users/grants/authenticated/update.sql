-- Revert: schemas/launchql_public/tables/users/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_public".users FROM authenticated;
COMMIT;  

