-- Deploy schemas/projects_public/procedures/remove_project_secret to pg

-- requires: schemas/projects_public/schema
-- requires: schemas/projects_private/tables/project_secrets/table

BEGIN;

CREATE FUNCTION projects_public.remove_project_secret(
  proj_id uuid,
  secret_name text
)
  RETURNS boolean
  AS $$
DECLARE
  v_proj projects_public.project;
  v_master_secret projects_private.project_secrets;
  v_master_key text;
BEGIN
  IF (secret_name = 'MASTER_KEY') THEN
    RETURN FALSE;
  END IF;
  DELETE FROM projects_private.project_secrets
  WHERE project_id = proj_id
    AND name = secret_name;
  RETURN TRUE;
END
$$
LANGUAGE 'plpgsql'
VOLATILE;

COMMIT;
