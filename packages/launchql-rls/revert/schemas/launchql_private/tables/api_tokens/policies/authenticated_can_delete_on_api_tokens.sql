-- Revert: schemas/launchql_private/tables/api_tokens/policies/authenticated_can_delete_on_api_tokens from pg

BEGIN;
DROP POLICY authenticated_can_delete_on_api_tokens ON "launchql_rls_private".api_tokens;
COMMIT;  

