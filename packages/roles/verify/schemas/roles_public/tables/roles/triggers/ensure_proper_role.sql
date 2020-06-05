-- Verify schemas/roles_public/tables/roles/triggers/ensure_proper_role  on pg

BEGIN;

SELECT verify_trigger ('roles_public.ensure_proper_role');

ROLLBACK;
