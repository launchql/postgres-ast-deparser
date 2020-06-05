-- Verify schemas/roles_private/procedures/send_membership_invite_email  on pg

BEGIN;

SELECT verify_function ('roles_private.send_membership_invite_email');

ROLLBACK;
