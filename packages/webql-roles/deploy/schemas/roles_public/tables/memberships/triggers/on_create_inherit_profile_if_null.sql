-- Deploy schemas/roles_public/tables/memberships/triggers/on_create_inherit_profile_if_null to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/memberships/table

BEGIN;



CREATE FUNCTION roles_private.tg_on_create_inherit_profile_if_null()
RETURNS TRIGGER AS $$
DECLARE
  mbr roles_public.memberships;
BEGIN
 IF (NEW.profile_id IS NULL) THEN

  -- GET ORG PROFILE, IF EXISTS
  SELECT * FROM 
    roles_public.memberships m
      WHERE 
      m.organization_id=NEW.organization_id
      AND m.group_id=NEW.organization_id
      AND m.role_id=NEW.role_id
  INTO mbr;

  IF (FOUND) THEN
    NEW.profile_id = mbr.profile_id;
  END IF;   

 END IF;

 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER on_create_inherit_profile_if_null
BEFORE INSERT ON roles_public.memberships
FOR EACH ROW
EXECUTE PROCEDURE roles_private.tg_on_create_inherit_profile_if_null ();


COMMIT;
