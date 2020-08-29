-- Deploy schemas/projects_private/procedures/get_project_master_key to pg
-- requires: schemas/projects_private/schema
-- requires: schemas/projects_private/tables/project_secrets/table
-- requires: schemas/projects_public/tables/project/table

BEGIN;

CREATE FUNCTION projects_private.get_project_master_key (
  proj_id uuid
)
  RETURNS text
  AS $$
DECLARE
  v_master_secret projects_private.project_secrets;
  v_master_key text;
BEGIN
  SELECT
    *
  FROM
    projects_private.project_secrets s
  WHERE
    s.name = 'MASTER_KEY'
    AND s.project_id = proj_id INTO v_master_secret;
  IF (NOT FOUND) THEN
    INSERT INTO projects_private.project_secrets (project_id, name, value)
      VALUES (proj_id, 'MASTER_KEY', pgp_sym_encrypt(encode(gen_random_bytes(48), 'hex'), proj_id::text, 'compress-algo=1, cipher-algo=aes256'))
    RETURNING
      * INTO v_master_secret;
  END IF;
  SELECT
    *
  FROM
    pgp_sym_decrypt(v_master_secret.value, proj_id::text) INTO v_master_key;
  IF (length(v_master_key) < 48) THEN
    RAISE
    EXCEPTION 'SECRETS_NO_KEY_EXISTS';
  END IF;
  RETURN v_master_key;
END
$$
LANGUAGE 'plpgsql'
VOLATILE;

COMMIT;

