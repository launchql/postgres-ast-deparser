-- Deploy schemas/projects_private/procedures/get_project_secret to pg
-- requires: schemas/projects_private/schema
-- requires: schemas/projects_public/tables/project/table
-- requires: schemas/projects_private/tables/project_secrets/table
-- requires: schemas/projects_private/procedures/get_project_master_key

BEGIN;

CREATE FUNCTION projects_private.get_project_secret (
  proj_id uuid,
  secret_name text
)
  RETURNS text
  AS $$
DECLARE
  v_master_key text;
  v_secret projects_private.project_secrets;
BEGIN
  IF (secret_name = 'MASTER_KEY') THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  SELECT
    projects_private.get_project_master_key (proj_id) INTO v_master_key;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  SELECT
    *
  FROM
    projects_private.project_secrets s
  WHERE
    s.name = secret_name
    AND s.project_id = proj_id INTO v_secret;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  RETURN pgp_sym_decrypt(v_secret.value, v_master_key);
END
$$
LANGUAGE 'plpgsql'
STABLE;

COMMIT;

