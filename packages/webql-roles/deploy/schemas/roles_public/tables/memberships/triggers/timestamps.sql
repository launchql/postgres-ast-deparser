-- Deploy schemas/roles_public/tables/memberships/triggers/timestamps to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/memberships/table

BEGIN;

ALTER TABLE roles_public.memberships ADD COLUMN created_at TIMESTAMPTZ;
ALTER TABLE roles_public.memberships ALTER COLUMN created_at SET DEFAULT NOW();

ALTER TABLE roles_public.memberships ADD COLUMN updated_at TIMESTAMPTZ;
ALTER TABLE roles_public.memberships ALTER COLUMN updated_at SET DEFAULT NOW();

CREATE TRIGGER update_roles_public_memberships_modtime
BEFORE UPDATE OR INSERT ON roles_public.memberships
FOR EACH ROW
EXECUTE PROCEDURE tg_update_timestamps();

COMMIT;
