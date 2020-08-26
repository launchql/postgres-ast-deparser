-- Deploy schemas/permissions_private/tables/profile_permissions/triggers/on_insert_set_org_id to pg

-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/permissions_private/schema
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/permissions_private/tables/profile_permissions/table

BEGIN;



CREATE FUNCTION permissions_private.tg_on_insert_set_org_id()
RETURNS TRIGGER AS $$
DECLARE
  v_profile permissions_public.profile;
BEGIN
  SELECT * FROM permissions_public.profile
    WHERE id=NEW.profile_id
    INTO v_profile
    ;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'OBJECT_NOT_FOUND';
  END IF;

  NEW.organization_id = v_profile.organization_id;

 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER on_insert_set_org_id
BEFORE INSERT ON permissions_private.profile_permissions
FOR EACH ROW
EXECUTE PROCEDURE permissions_private.tg_on_insert_set_org_id ();



COMMIT;
