-- Verify schemas/roles_public/tables/membership_invites/indexes/uniq_email_invites  on pg

BEGIN;

SELECT verify_index ('roles_public.membership_invites', 'uniq_email_invites');

ROLLBACK;
