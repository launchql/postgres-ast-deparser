-- Deploy schemas/files_public/tables/buckets/triggers/create_remote_bucket to pg
-- requires: schemas/files_public/schema
-- requires: schemas/files_public/tables/buckets/table

BEGIN;
CREATE FUNCTION files_private.tg_create_remote_bucket ()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF (NEW.exists IS FALSE) THEN
    PERFORM
      app_jobs.add_job ('files__create_remote_bucket',
        json_build_object('id', NEW.id::text));
  END IF;
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'
VOLATILE SECURITY DEFINER;

CREATE TRIGGER create_remote_bucket
  AFTER INSERT ON files_public.buckets
  FOR EACH ROW
  EXECUTE PROCEDURE files_private.tg_create_remote_bucket ();
COMMIT;

