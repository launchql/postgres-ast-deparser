-- Verify schemas/roles_public/tables/membership_invites/indexes/membership_invites_organization_id_idx  on pg

BEGIN;

SELECT verify_index ('roles_public.membership_invites', 'membership_invites_organization_id_idx');

ROLLBACK;
