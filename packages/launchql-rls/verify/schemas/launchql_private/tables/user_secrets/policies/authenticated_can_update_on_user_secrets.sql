-- Verify: schemas/launchql_private/tables/user_secrets/policies/authenticated_can_update_on_user_secrets on pg

BEGIN;
SELECT verify_policy('authenticated_can_update_on_user_secrets', 'launchql_rls_private.user_secrets');
COMMIT;  

