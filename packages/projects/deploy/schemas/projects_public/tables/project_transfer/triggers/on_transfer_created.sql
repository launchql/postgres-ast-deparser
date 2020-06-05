-- Deploy schemas/projects_public/tables/project_transfer/triggers/on_transfer_created to pg

-- requires: schemas/projects_private/schema
-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project_transfer/table

BEGIN;

CREATE FUNCTION projects_private.tg_on_transfer_created()
RETURNS TRIGGER AS $$
DECLARE
  v_proj projects_public.project;
  v_owner roles_public.roles;
  v_new_owner roles_public.roles;
BEGIN

  SELECT * FROM projects_public.project WHERE id=NEW.project_id
  INTO v_proj;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_NOT_FOUND';
  END IF;

  SELECT * FROM roles_public.roles WHERE id=v_proj.owner_id
  INTO v_owner;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_OWNER_NOT_FOUND';
  END IF;

  SELECT * FROM roles_public.roles WHERE id=NEW.new_owner_id
  INTO v_new_owner;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_NEW_OWNER_NOT_FOUND';
  END IF;


  IF (v_new_owner.type = 'Team'::roles_public.role_type) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_NOT_FOR_TEAMS';
  END IF;

  NEW.current_owner_id = v_proj.owner_id;
  NEW.sender_id = roles_public.current_role_id();

  -- Trigger project transfer email
  PERFORM
    app_jobs.add_job ('project__transfer_project_email',
        json_build_object(
          'project_id', NEW.project_id::text,
          'current_owner_id', NEW.current_owner_id::text,
          'new_owner_id', NEW.new_owner_id::text,
          'sender_id', NEW.sender_id::text,
          'transfer_token', NEW.transfer_token
        ));

 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_transfer_created
BEFORE INSERT ON projects_public.project_transfer
FOR EACH ROW
EXECUTE PROCEDURE projects_private.tg_on_transfer_created ();

COMMIT;
