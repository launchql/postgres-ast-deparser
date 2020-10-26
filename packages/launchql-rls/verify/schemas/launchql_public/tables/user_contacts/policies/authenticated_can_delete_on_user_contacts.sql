-- Verify: schemas/launchql_public/tables/user_contacts/policies/authenticated_can_delete_on_user_contacts on pg

BEGIN;
SELECT verify_policy('authenticated_can_delete_on_user_contacts', 'launchql_rls_public.user_contacts');
COMMIT;  

