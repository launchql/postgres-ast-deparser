-- Revert: schemas/launchql_private/tables/api_tokens/grants/authenticated/insert from pg

BEGIN;
REVOKE INSERT ON TABLE "launchql_rls_private".api_tokens FROM authenticated;
COMMIT;  

