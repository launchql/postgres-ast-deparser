-- Verify schemas/roles_public/tables/memberships/indexes/memberships_organization_idx  on pg

BEGIN;

SELECT verify_index ('roles_public.memberships', 'memberships_organization_idx');

ROLLBACK;
