-- Verify schemas/roles_public/tables/roles/table on pg

BEGIN;

SELECT
verify_table ('roles_public.roles');

ROLLBACK;
