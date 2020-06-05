-- Verify schemas/roles_public/tables/roles/indexes/unique_username  on pg

BEGIN;

SELECT verify_index ('roles_public.roles', 'unique_username');

ROLLBACK;
