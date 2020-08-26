-- Deploy schemas/roles_public/tables/roles/triggers/timestamps to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

ALTER TABLE roles_public.roles ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE roles_public.roles ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE roles_public.roles ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE roles_public.roles ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_roles_public_roles_modtime
BEFORE UPDATE OR INSERT ON roles_public.roles
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
