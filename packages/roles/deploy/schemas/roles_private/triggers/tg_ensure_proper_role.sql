-- Deploy schemas/roles_private/triggers/tg_ensure_proper_role to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/roles_public/types/role_type
-- requires: schemas/roles_private/procedures/validate_role_parent

BEGIN;

CREATE FUNCTION roles_private.tg_ensure_proper_role()
RETURNS TRIGGER
AS $$
BEGIN


  IF (NEW.type = 'Team'::roles_public.role_type) THEN
    IF (NEW.organization_id IS NULL) THEN
      RAISE EXCEPTION 'TEAMS_REQUIRE_ORGANIZATION_ID';
    END IF;
    IF (NEW.parent_id IS NULL) THEN
      NEW.parent_id = NEW.organization_id;
    END IF;
    PERFORM roles_private.validate_role_parent(NEW);
    IF (NEW.username IS NOT NULL) THEN
      RAISE EXCEPTION 'TEAMS_NO_USERNAME';
    END IF;
  END IF;

  IF (NEW.type = 'Organization'::roles_public.role_type) THEN
    NEW.organization_id = NEW.id;
    IF (NEW.parent_id IS NOT NULL) THEN
      RAISE EXCEPTION 'ROLES_ORGANIZATION_NO_PARENT';
    END IF;
  END IF;

  IF (NEW.type = 'User'::roles_public.role_type) THEN
    NEW.organization_id = NEW.id;
    IF (NEW.parent_id IS NOT NULL) THEN
      RAISE EXCEPTION 'ROLES_USER_NO_PARENT';
    END IF;
  END IF;

  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' STABLE;

COMMIT;
