-- Deploy schemas/projects_public/procedures/upsert_project_secret to pg
-- requires: schemas/projects_public/schema
-- requires: schemas/projects_private/tables/project_secrets/table
-- requires: schemas/projects_public/tables/project/table
-- requires: schemas/projects_private/procedures/get_project_master_key

BEGIN;

CREATE FUNCTION projects_public.upsert_project_secret (
  proj_id uuid,
  secret_name text,
  value text
)
  RETURNS boolean
  AS $$
DECLARE
  v_proj projects_public.project;
  v_master_secret projects_private.project_secrets;
  v_master_key text;
  v_value bytea;
BEGIN
  IF (secret_name = 'MASTER_KEY') THEN
    RETURN FALSE;
  END IF;
  SELECT
    projects_private.get_project_master_key (proj_id) INTO v_master_key;
  IF (NOT FOUND) THEN
    RAISE
    EXCEPTION 'GENERIC_NO_OBJECT_EXISTS';
  END IF;
  SELECT
    pgp_sym_encrypt(value, v_master_key, 'compress-algo=1, cipher-algo=aes256') INTO v_value;
  INSERT INTO projects_private.project_secrets (project_id, name, value)
    VALUES (proj_id, secret_name, v_value) ON CONFLICT (project_id, name)
    DO
    UPDATE
    SET
      value = EXCLUDED.value;
  RETURN TRUE;
END
$$
LANGUAGE 'plpgsql'
VOLATILE;

COMMIT;

