-- Verify: schemas/launchql_public/tables/users/policies/authenticated_can_delete_on_users on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_users', 'launchql_rls_public.users');
COMMIT;  

