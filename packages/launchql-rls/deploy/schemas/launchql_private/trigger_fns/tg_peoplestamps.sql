-- Deploy: schemas/launchql_private/trigger_fns/tg_peoplestamps to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema

BEGIN;

CREATE FUNCTION "launchql_private".tg_peoplestamps()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
      NEW.updated_by = "launchql_public".get_current_user_id();
      NEW.created_by = "launchql_public".get_current_user_id();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.updated_by = OLD.updated_by;
      NEW.created_by = "launchql_public".get_current_user_id();
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';
COMMIT;
