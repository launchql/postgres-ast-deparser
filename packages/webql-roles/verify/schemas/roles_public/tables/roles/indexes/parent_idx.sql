-- Verify schemas/roles_public/tables/roles/indexes/parent_idx  on pg

BEGIN;

SELECT verify_index ('roles_public.roles', 'parent_idx');

ROLLBACK;
