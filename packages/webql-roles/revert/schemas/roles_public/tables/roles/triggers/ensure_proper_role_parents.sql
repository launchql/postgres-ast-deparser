-- Revert schemas/roles_public/tables/roles/triggers/ensure_proper_role_parents from pg

BEGIN;

DROP TRIGGER ensure_proper_role_parents ON roles_public.roles;

COMMIT;
