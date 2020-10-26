-- Verify: schemas/launchql_public/tables/user_settings/policies/authenticated_can_delete_on_user_settings on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_user_settings', 'launchql_rls_public.user_settings');
COMMIT;  

