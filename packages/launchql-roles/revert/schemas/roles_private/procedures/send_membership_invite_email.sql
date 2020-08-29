-- Revert schemas/roles_private/procedures/send_membership_invite_email from pg

BEGIN;

DROP FUNCTION roles_private.send_membership_invite_email;

COMMIT;
