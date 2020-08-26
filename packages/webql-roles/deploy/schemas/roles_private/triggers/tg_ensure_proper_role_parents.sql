-- Deploy schemas/roles_private/triggers/tg_ensure_proper_role_parents to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_private/procedures/validate_role_parent

BEGIN;

CREATE FUNCTION roles_private.tg_ensure_proper_role_parents()
RETURNS TRIGGER as $$
BEGIN
  PERFORM roles_private.validate_role_parent(NEW);
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' STABLE;

COMMIT;
