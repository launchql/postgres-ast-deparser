-- Revert: schemas/launchql_public/tables/goals/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_public".goals FROM authenticated;
COMMIT;  

