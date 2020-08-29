-- Deploy schemas/services_public/tables/config/triggers/only_one_record to pg

-- requires: schemas/services_public/schema
-- requires: schemas/services_public/tables/config/table

BEGIN;

CREATE FUNCTION services_private.tg_only_one_record()
RETURNS TRIGGER AS $$
DECLARE
  c int = 0;
BEGIN
 SELECT count(*) FROM 
    services_public.config
 INTO c;

 IF (c = 0) THEN
     RETURN NEW;
 END IF;

 RAISE EXCEPTION 'ONLY_ONE_RECORD';
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER only_one_record
BEFORE INSERT ON services_public.config
FOR EACH ROW
EXECUTE PROCEDURE services_private.tg_only_one_record ();

COMMIT;
