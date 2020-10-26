-- Revert: schemas/launchql_public/tables/user_connections/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ( accepted ) ON TABLE "launchql_rls_public".user_connections FROM authenticated;
COMMIT;  

