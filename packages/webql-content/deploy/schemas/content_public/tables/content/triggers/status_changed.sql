-- Deploy schemas/content_public/tables/content/triggers/status_changed to pg
-- requires: schemas/content_public/schema
-- requires: schemas/content_public/tables/content/table
-- requires: schemas/content_public/tables/content/alterations/alter_table_add_published_at
-- requires: schemas/content_public/tables/content/alterations/alter_table_add_published_by

BEGIN;

CREATE FUNCTION content_private.tg_status_changed ()
  RETURNS TRIGGER
  AS $$
BEGIN
  NEW.published_by = roles_public.current_role_id ();
  NEW.published_at = NOW();
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE;

CREATE TRIGGER status_changed
  BEFORE UPDATE ON content_public.content
  FOR EACH ROW
  WHEN (NEW.status IS DISTINCT FROM OLD.status
    AND NEW.status = 'published')
  EXECUTE PROCEDURE content_private.tg_status_changed ();

COMMIT;

