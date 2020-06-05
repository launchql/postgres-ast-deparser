-- Verify schemas/roles_public/tables/roles/policies/enable_row_level_security on pg

BEGIN;

SELECT verify_security('roles_public.roles');

ROLLBACK;
