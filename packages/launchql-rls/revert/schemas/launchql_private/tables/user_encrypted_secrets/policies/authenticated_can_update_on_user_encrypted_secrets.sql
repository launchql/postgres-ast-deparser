-- Revert: schemas/launchql_private/tables/user_encrypted_secrets/policies/authenticated_can_update_on_user_encrypted_secrets from pg

BEGIN;
DROP POLICY authenticated_can_update_on_user_encrypted_secrets ON "launchql_rls_private".user_encrypted_secrets;
COMMIT;  

