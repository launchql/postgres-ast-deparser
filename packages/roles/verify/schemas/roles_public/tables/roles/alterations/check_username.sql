-- Verify schemas/roles_public/tables/roles/alterations/check_username  on pg

BEGIN;

SELECT verify_constraint('roles_public.roles', 'fk_roles_public_roles_username');

ROLLBACK;
