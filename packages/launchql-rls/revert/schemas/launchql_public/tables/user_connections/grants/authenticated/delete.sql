-- Revert: schemas/launchql_public/tables/user_connections/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".user_connections FROM authenticated;
COMMIT;  

