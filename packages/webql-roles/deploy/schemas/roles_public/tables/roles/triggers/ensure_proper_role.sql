-- Deploy schemas/roles_public/tables/roles/triggers/ensure_proper_role to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_private/triggers/tg_ensure_proper_role

BEGIN;

CREATE TRIGGER ensure_proper_role
BEFORE INSERT ON roles_public.roles
FOR EACH ROW
EXECUTE PROCEDURE roles_private.tg_ensure_proper_role ();

COMMIT;
