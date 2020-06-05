-- Deploy schemas/roles_public/tables/roles/triggers/ensure_proper_role_parents to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_private/triggers/tg_ensure_proper_role_parents

BEGIN;

CREATE TRIGGER ensure_proper_role_parents
BEFORE UPDATE ON roles_public.roles
FOR EACH ROW
    WHEN ( NEW.parent_id IS DISTINCT FROM OLD.parent_id)
EXECUTE PROCEDURE roles_private.tg_ensure_proper_role_parents ();

COMMIT;
