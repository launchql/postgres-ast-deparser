-- Verify schemas/roles_public/tables/role_settings/policies/enable_row_level_security  on pg

BEGIN;

SELECT verify_security ('roles_public.role_settings');

ROLLBACK;
