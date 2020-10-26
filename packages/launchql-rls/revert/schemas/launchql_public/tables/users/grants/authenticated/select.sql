-- Revert: schemas/launchql_public/tables/users/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".users FROM authenticated;
COMMIT;  

