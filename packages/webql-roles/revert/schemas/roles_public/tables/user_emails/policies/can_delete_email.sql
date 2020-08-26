-- Revert schemas/roles_public/tables/user_emails/policies/can_delete_email from pg

BEGIN;


REVOKE DELETE ON TABLE roles_public.user_emails FROM authenticated;


DROP POLICY delete_own ON roles_public.user_emails;

COMMIT;
