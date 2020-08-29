-- Verify schemas/roles_public/tables/membership_invites/indexes/uniq_role_id_invites  on pg

BEGIN;

SELECT verify_index ('roles_public.membership_invites', 'uniq_role_id_invites');

ROLLBACK;
