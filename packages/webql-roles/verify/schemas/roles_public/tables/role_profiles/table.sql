-- Verify schemas/roles_public/tables/role_profiles/table on pg

BEGIN;

SELECT verify_table ('roles_public.role_profiles');

ROLLBACK;
