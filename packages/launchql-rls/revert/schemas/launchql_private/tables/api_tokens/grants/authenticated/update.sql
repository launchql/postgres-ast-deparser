-- Revert: schemas/launchql_private/tables/api_tokens/grants/authenticated/update from pg

BEGIN;
REVOKE UPDATE ON TABLE "launchql_rls_private".api_tokens FROM authenticated;
COMMIT;  

