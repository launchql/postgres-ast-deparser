-- Revert: schemas/launchql_public/tables/user_characteristics/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".user_characteristics FROM authenticated;
COMMIT;  

