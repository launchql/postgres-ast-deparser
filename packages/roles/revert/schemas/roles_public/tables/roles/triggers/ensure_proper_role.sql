-- Revert schemas/roles_public/tables/roles/triggers/ensure_proper_role from pg

BEGIN;

DROP TRIGGER ensure_proper_role ON roles_public.roles;

COMMIT;
