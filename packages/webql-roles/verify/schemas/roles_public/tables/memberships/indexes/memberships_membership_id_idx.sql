-- Verify schemas/roles_public/tables/memberships/indexes/memberships_membership_id_idx  on pg

BEGIN;

SELECT verify_index ('roles_public.memberships', 'memberships_membership_id_idx');

ROLLBACK;
