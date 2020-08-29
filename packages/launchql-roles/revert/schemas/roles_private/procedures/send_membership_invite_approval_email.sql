-- Revert schemas/roles_private/procedures/send_membership_invite_approval_email from pg

BEGIN;

DROP FUNCTION roles_private.send_membership_invite_approval_email;

COMMIT;
