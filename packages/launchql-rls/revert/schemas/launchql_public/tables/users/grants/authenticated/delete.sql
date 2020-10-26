-- Revert: schemas/launchql_public/tables/users/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".users FROM authenticated;
COMMIT;  

