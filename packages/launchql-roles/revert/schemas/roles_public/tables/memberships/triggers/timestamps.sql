-- Revert schemas/roles_public/tables/memberships/triggers/timestamps from pg

BEGIN;

ALTER TABLE roles_public.memberships DROP COLUMN created_at;
ALTER TABLE roles_public.memberships DROP COLUMN updated_at;
DROP TRIGGER update_roles_public_memberships_modtime ON roles_public.memberships;

COMMIT;
