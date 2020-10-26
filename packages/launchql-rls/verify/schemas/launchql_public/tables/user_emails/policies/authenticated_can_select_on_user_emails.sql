-- Verify: schemas/launchql_public/tables/user_emails/policies/authenticated_can_select_on_user_emails on pg

BEGIN;
SELECT verify_policy('authenticated_can_select_on_user_emails', 'launchql_rls_public.user_emails');
COMMIT;  

