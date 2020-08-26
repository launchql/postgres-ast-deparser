-- Revert schemas/projects_public/tables/project_transfer/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE projects_public.project_transfers
    DISABLE ROW LEVEL SECURITY;

COMMIT;
