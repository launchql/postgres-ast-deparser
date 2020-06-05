-- Deploy procedures/tg_update_peoplestamps to pg

-- requires: schemas/roles_public/procedures/current_role_id

BEGIN;

CREATE FUNCTION tg_update_peoplestamps()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
      NEW.created_by = roles_public.current_role_id();
      NEW.updated_by = roles_public.current_role_id();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.created_by = OLD.created_by;
      NEW.updated_by = roles_public.current_role_id();
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

COMMIT;
