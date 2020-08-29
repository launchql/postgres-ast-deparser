-- Verify schemas/roles_public/tables/user_emails/policies/can_select_email  on pg

BEGIN;

SELECT verify_policy ('select_own', 'roles_public.user_emails');

SELECT has_table_privilege('authenticated', 'roles_public.user_emails', 'SELECT');

ROLLBACK;
