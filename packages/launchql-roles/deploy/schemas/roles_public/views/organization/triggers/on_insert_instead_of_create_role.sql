-- Deploy schemas/roles_public/views/organization/triggers/on_insert_instead_of_create_role to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/types/role_type
-- requires: schemas/roles_public/views/organization/view
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/procedures/register_organization

BEGIN;
CREATE FUNCTION roles_private.tg_on_insert_instead_of_create_role ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_role roles_public.roles;
BEGIN
  SELECT
    *
  FROM
    roles_public.register_organization (NEW.username) INTO v_role;
  RETURN v_role;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;
CREATE TRIGGER on_insert_instead_of_create_role INSTEAD OF INSERT ON roles_public.organization
FOR EACH ROW
EXECUTE PROCEDURE roles_private.tg_on_insert_instead_of_create_role ();
COMMIT;

