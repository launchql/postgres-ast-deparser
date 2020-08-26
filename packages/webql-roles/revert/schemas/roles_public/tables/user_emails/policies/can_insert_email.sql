-- Revert schemas/roles_public/tables/user_emails/policies/can_insert_email from pg

BEGIN;


REVOKE INSERT ON TABLE roles_public.user_emails FROM authenticated;


DROP POLICY insert_own ON roles_public.user_emails;

COMMIT;
