-- Verify schemas/roles_public/tables/membership_invites/triggers/invite_member_email  on pg

BEGIN;

SELECT verify_function ('roles_private.invite_member_email_fn', current_user);
SELECT verify_trigger ('roles_private.invite_member_email');

ROLLBACK;
