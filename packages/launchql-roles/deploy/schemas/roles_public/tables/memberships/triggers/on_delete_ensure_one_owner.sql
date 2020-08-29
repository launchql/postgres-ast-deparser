-- Deploy schemas/roles_public/tables/memberships/triggers/on_delete_ensure_one_owner to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/memberships/table
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type
-- requires: schemas/permissions_public/tables/profile/table

BEGIN;



CREATE FUNCTION roles_private.tg_on_delete_ensure_one_owner()
RETURNS TRIGGER
AS $$
DECLARE
  grant_role roles_public.roles;
  membership_profile permissions_public.profile;
  
  admin_grant roles_public.memberships;
  
BEGIN

  SELECT * FROM roles_public.roles r
  WHERE
      r.id = OLD.group_id
  INTO grant_role;

  IF (NOT FOUND) THEN
    -- this means the organization or team was removed
    RETURN OLD;
  END IF;

  SELECT * FROM permissions_public.profile p
  WHERE
      p.id = OLD.profile_id
  INTO membership_profile;

  IF (NOT FOUND) THEN
    -- this means was removed
    RETURN OLD;
  END IF;

  -- we only care about Organizations
  IF (grant_role.type != 'Organization'::roles_public.role_type) THEN
    RETURN OLD;
  END IF;

  -- we only care about Removing Administrator
  -- IF (membership_profile.name != 'Administrator' OR membership_profile.name != 'Owner') THEN
  --   RETURN OLD;
  -- END IF;

  -- we only care about Removing Owners
  IF (membership_profile.name != 'Owner') THEN
    RETURN OLD;
  END IF;

  SELECT *
      FROM roles_public.memberships m
      JOIN permissions_public.profile p
      ON (m.profile_id = p.id AND m.organization_id = p.organization_id)
  WHERE 
    p.name = 'Owner'
    AND m.role_id != OLD.role_id

    AND m.group_id = OLD.group_id
    AND m.organization_id = OLD.organization_id
  INTO admin_grant;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'ORGANIZATIONS_REQUIRE_ONE_OWNER';
  END IF;

  RETURN OLD;
END;
$$
LANGUAGE 'plpgsql' STABLE SECURITY DEFINER;


CREATE TRIGGER on_delete_ensure_one_owner
BEFORE DELETE ON roles_public.memberships
FOR EACH ROW
WHEN (OLD.inherited = false)
EXECUTE PROCEDURE roles_private.tg_on_delete_ensure_one_owner ();

COMMIT;
