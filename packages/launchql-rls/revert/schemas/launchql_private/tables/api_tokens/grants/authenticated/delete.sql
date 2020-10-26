-- Revert: schemas/launchql_private/tables/api_tokens/grants/authenticated/delete from pg

BEGIN;
REVOKE DELETE ON TABLE "launchql_rls_private".api_tokens FROM authenticated;
COMMIT;  

