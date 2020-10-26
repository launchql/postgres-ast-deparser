-- Revert: schemas/launchql_public/tables/user_characteristics/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_public".user_characteristics FROM authenticated;
COMMIT;  

