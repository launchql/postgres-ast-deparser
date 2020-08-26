-- Deploy schemas/roles_private/triggers/tg_immutable_role_properties to pg

-- requires: schemas/roles_private/schema

BEGIN;

CREATE FUNCTION roles_private.tg_immutable_role_properties() RETURNS TRIGGER
as $$
BEGIN
  RAISE EXCEPTION 'IMMUTABLE_PROPERTIES';
END;
$$
LANGUAGE 'plpgsql' STABLE;

COMMIT;
