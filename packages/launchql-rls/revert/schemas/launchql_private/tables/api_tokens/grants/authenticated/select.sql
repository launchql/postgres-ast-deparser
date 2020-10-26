-- Revert: schemas/launchql_private/tables/api_tokens/grants/authenticated/select from pg

BEGIN;
REVOKE SELECT ON TABLE "launchql_rls_private".api_tokens FROM authenticated;
COMMIT;  

