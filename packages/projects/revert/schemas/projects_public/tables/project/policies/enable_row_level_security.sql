-- Revert schemas/projects_public/tables/project/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE projects_public.project
    DISABLE ROW LEVEL SECURITY;

COMMIT;
