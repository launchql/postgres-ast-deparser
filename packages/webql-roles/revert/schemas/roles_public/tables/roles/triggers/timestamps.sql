-- Revert schemas/roles_public/tables/roles/triggers/timestamps from pg

BEGIN;

ALTER TABLE roles_public.roles DROP COLUMN created_at;
ALTER TABLE roles_public.roles DROP COLUMN updated_at;
DROP TRIGGER update_roles_public_roles_modtime ON roles_public.roles;

COMMIT;
