-- Deploy schemas/roles_public/tables/memberships/triggers/on_create_cascade_hierarchy to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/roles_private/procedures/membership_cascade_hierarchy

BEGIN;

CREATE FUNCTION roles_private.tg_on_create_cascade_hierarchy ()
  RETURNS TRIGGER
  AS $$
BEGIN
  PERFORM roles_private.membership_cascade_hierarchy(NEW);
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE
SECURITY DEFINER;

CREATE TRIGGER on_create_cascade_hierarchy
  AFTER INSERT ON roles_public.memberships
  FOR EACH ROW
  WHEN (NEW.inherited != true)
  EXECUTE PROCEDURE roles_private.tg_on_create_cascade_hierarchy ();
COMMIT;

