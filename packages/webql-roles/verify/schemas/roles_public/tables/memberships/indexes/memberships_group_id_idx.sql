-- Verify schemas/roles_public/tables/memberships/indexes/memberships_group_id_idx  on pg

BEGIN;

SELECT verify_index ('roles_public.memberships', 'memberships_group_id_idx');

ROLLBACK;
