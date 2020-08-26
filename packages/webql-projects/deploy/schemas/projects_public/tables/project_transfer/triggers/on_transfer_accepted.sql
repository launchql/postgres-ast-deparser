-- Deploy schemas/projects_public/tables/project_transfer/triggers/on_transfer_accepted to pg

-- requires: schemas/projects_private/schema
-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project_transfer/table

BEGIN;

CREATE FUNCTION projects_private.tg_on_transfer_accepted()
RETURNS TRIGGER AS $$
BEGIN

  IF (NEW.transferred) THEN
    RAISE EXCEPTION 'PROJECT_TRANSFERS_ALREADY_TRANSFERRED';
  END IF;

-- TODO [ ] update organization_id
-- TODO [ ] remove grants, maybe we do not even need them by default?
-- TODO [ ] use username or something better than id?
-- TODO [ ] when proj name conflicts?

  IF (NEW.accepted) THEN
    UPDATE projects_public.project
      SET owner_id=NEW.new_owner_id
      WHERE id=NEW.project_id;

    NEW.transferred = TRUE;
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;

CREATE TRIGGER on_transfer_accepted
BEFORE UPDATE ON projects_public.project_transfer
FOR EACH ROW
WHEN (NEW.accepted IS DISTINCT FROM OLD.accepted)
EXECUTE PROCEDURE projects_private.tg_on_transfer_accepted ();



COMMIT;
