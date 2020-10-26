-- Revert: schemas/launchql_public/tables/user_connections/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".user_connections FROM authenticated;
COMMIT;  

