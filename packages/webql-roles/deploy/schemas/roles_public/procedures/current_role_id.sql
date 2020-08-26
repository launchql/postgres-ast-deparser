-- Deploy schemas/roles_public/procedures/current_role_id to pg
-- requires: schemas/roles_public/schema
BEGIN;

CREATE FUNCTION roles_public.current_role_id ()
  RETURNS uuid
AS $$
DECLARE
  role_id uuid;
BEGIN
  IF current_setting('jwt.claims.role_id', TRUE)
    IS NOT NULL THEN
    BEGIN
      role_id = current_setting('jwt.claims.role_id', TRUE)::uuid;
    EXCEPTION
      WHEN OTHERS THEN
      RAISE NOTICE 'Invalid UUID value: "%".  Returning NULL.', current_setting('jwt.claims.role_id', TRUE);
    RETURN NULL;
    END;
    RETURN role_id;
  ELSE
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql' STABLE;

GRANT EXECUTE ON FUNCTION roles_public.current_role_id TO anonymous, authenticated;

COMMIT;

