-- Verify schemas/roles_public/tables/role_profiles/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('roles_public.role_profiles');

ROLLBACK;
