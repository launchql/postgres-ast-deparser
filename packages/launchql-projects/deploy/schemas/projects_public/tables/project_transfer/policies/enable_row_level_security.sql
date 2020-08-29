-- Deploy schemas/projects_public/tables/project_transfer/policies/enable_row_level_security to pg

-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project_transfer/table

BEGIN;

ALTER TABLE projects_public.project_transfer
    ENABLE ROW LEVEL SECURITY;

COMMIT;
