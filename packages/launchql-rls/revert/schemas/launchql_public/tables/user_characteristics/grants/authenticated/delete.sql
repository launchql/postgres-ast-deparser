-- Revert: schemas/launchql_public/tables/user_characteristics/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_public".user_characteristics FROM authenticated;
COMMIT;  

