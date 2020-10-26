-- Revert: schemas/launchql_public/tables/users/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".users FROM authenticated;
COMMIT;  

