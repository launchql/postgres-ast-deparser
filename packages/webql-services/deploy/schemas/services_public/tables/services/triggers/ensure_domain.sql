-- Deploy schemas/services_public/tables/services/triggers/ensure_domain to pg

-- requires: schemas/services_public/schema
-- requires: schemas/services_public/tables/services/table
-- requires: schemas/services_public/tables/config/table

BEGIN;

CREATE FUNCTION services_private.tg_ensure_domain()
RETURNS TRIGGER AS $$
DECLARE
  def_name text;
BEGIN
 IF (NEW.domain IS NULL) THEN
    SELECT domain FROM services_public.config
        WHERE id = 1
    INTO def_name;
    NEW.domain = def_name;    
 END IF;
 RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER ensure_domain
BEFORE INSERT ON services_public.services
FOR EACH ROW
EXECUTE PROCEDURE services_private.tg_ensure_domain ();

COMMIT;
