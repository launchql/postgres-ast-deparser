-- Deploy: schemas/launchql_private/trigger_fns/tg_timestamps to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema

BEGIN;

CREATE FUNCTION "launchql_private".tg_timestamps()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
      NEW.updated_at = NOW();
      NEW.created_at = NOW();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.updated_at = OLD.updated_at;
      NEW.created_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';
COMMIT;
