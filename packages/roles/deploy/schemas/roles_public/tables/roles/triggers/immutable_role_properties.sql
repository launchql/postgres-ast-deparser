-- Deploy schemas/roles_public/tables/roles/triggers/immutable_role_properties to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_private/triggers/tg_immutable_role_properties

BEGIN;

CREATE TRIGGER immutable_role_properties
BEFORE UPDATE ON roles_public.roles
FOR EACH ROW
    WHEN (
      NEW.type IS DISTINCT FROM OLD.type
      OR NEW.organization_id IS DISTINCT FROM OLD.organization_id
    )
EXECUTE PROCEDURE roles_private.tg_immutable_role_properties ();

COMMIT;
