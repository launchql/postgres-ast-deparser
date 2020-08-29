-- Verify schemas/roles_public/tables/roles/triggers/ensure_proper_role_parents  on pg

BEGIN;

SELECT verify_trigger ('roles_public.ensure_proper_role_parents');

ROLLBACK;
