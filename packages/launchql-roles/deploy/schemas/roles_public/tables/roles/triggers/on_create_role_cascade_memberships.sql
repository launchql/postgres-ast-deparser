-- Deploy schemas/roles_public/tables/roles/triggers/on_create_role_cascade_memberships to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_private/procedures/team_cascade_memberships

BEGIN;

CREATE FUNCTION roles_private.tg_on_create_role_cascade_memberships()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM
    roles_private.team_cascade_memberships(NEW.id, NEW.organization_id);
 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_create_role_cascade_memberships
AFTER INSERT ON roles_public.roles
FOR EACH ROW
WHEN (NEW.type = 'Team'::roles_public.role_type)
EXECUTE PROCEDURE roles_private.tg_on_create_role_cascade_memberships ();



COMMIT;
