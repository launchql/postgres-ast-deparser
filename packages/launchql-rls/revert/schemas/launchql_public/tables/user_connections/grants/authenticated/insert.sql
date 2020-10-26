-- Revert: schemas/launchql_public/tables/user_connections/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".user_connections FROM authenticated;
COMMIT;  

