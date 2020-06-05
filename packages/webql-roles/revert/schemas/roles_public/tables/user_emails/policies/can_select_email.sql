-- Revert schemas/roles_public/tables/user_emails/policies/can_select_email from pg

BEGIN;


REVOKE SELECT ON TABLE roles_public.user_emails FROM authenticated;


DROP POLICY select_own ON roles_public.user_emails;

COMMIT;
