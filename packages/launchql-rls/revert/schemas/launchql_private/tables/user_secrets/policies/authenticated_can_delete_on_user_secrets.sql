-- Revert: schemas/launchql_private/tables/user_secrets/policies/authenticated_can_delete_on_user_secrets from pg

BEGIN;
DROP POLICY authenticated_can_delete_on_user_secrets ON "launchql_rls_private".user_secrets;
COMMIT;  

