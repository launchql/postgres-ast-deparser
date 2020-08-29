-- Deploy schemas/projects_public/tables/project/triggers/on_insert_ensure_proper_owner to pg
-- requires: schemas/projects_private/schema
-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project/table

BEGIN;
CREATE FUNCTION projects_private.tg_on_insert_ensure_proper_owner ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_owner roles_public.roles;
BEGIN
  SELECT
    *
  FROM
    roles_public.roles
  WHERE
    id = NEW.owner_id INTO v_owner;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECTS_NO_OWNER';
  END IF;

  IF (v_owner.type = 'Team'::roles_public.role_type) THEN
    RAISE EXCEPTION 'PROJECTS_NOT_FOR_TEAMS';
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;
CREATE TRIGGER on_insert_ensure_proper_owner
  BEFORE INSERT ON projects_public.project
  FOR EACH ROW
  EXECUTE PROCEDURE projects_private.tg_on_insert_ensure_proper_owner ();
COMMIT;

