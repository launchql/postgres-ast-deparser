-- Verify schemas/roles_public/tables/roles/indexes/roles_organization_idx  on pg

BEGIN;

SELECT verify_index ('roles_public.roles', 'roles_organization_idx');

ROLLBACK;
