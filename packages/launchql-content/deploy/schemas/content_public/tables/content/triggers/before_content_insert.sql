-- Deploy schemas/content_public/tables/content/triggers/before_content_insert to pg
-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table

BEGIN;

CREATE FUNCTION content_private.tg_before_content_insert ()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_project projects_public.project;
BEGIN
  NEW.published_by = NULL;
  NEW.published_at = NULL;

  IF (NEW.status is NULL) THEN
    NEW.status = 'draft';
  END IF;

  SELECT * FROM projects_public.project
    WHERE id=NEW.project_id
    INTO v_project;

  IF (NOT FOUND) THEN
    RAISE EXCEPTION 'CONTENT_REQUIRES_PROJECT';
  END IF;
  
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;

CREATE TRIGGER before_content_insert
  BEFORE INSERT ON content_public.content
  FOR EACH ROW
  EXECUTE PROCEDURE content_private.tg_before_content_insert ();

COMMIT;

