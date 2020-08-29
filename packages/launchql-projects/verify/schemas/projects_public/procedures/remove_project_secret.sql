-- Verify schemas/projects_public/procedures/remove_project_secret  on pg

BEGIN;

SELECT verify_function ('projects_public.remove_project_secret');

ROLLBACK;
