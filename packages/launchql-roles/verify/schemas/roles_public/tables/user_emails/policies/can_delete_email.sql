-- Verify schemas/roles_public/tables/user_emails/policies/can_delete_email  on pg

BEGIN;

SELECT verify_policy ('delete_own', 'roles_public.user_emails');

SELECT has_table_privilege('authenticated', 'roles_public.user_emails', 'DELETE');

ROLLBACK;
