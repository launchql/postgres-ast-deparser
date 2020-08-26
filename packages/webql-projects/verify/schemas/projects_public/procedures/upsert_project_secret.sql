-- Verify schemas/projects_public/procedures/upsert_project_secret  on pg

BEGIN;

SELECT verify_function ('projects_public.upsert_project_secret');

ROLLBACK;
