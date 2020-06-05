-- Deploy schemas/roles_public/tables/roles/triggers/on_update_team_parent_cascade_memberships to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_private/procedures/cascade_restructured_organization

BEGIN;

CREATE FUNCTION roles_private.tg_on_update_team_parent_cascade_memberships()
RETURNS TRIGGER AS $$
BEGIN

  PERFORM
  roles_private.cascade_restructured_organization
    (NEW.organization_id)
  ;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_update_team_parent_cascade_memberships
AFTER UPDATE ON roles_public.roles
FOR EACH ROW
WHEN ( NEW.parent_id IS DISTINCT FROM OLD.parent_id )
EXECUTE PROCEDURE roles_private.tg_on_update_team_parent_cascade_memberships ();


COMMIT;
