-- Deploy schemas/projects_public/tables/project/policies/enable_row_level_security to pg

-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project/table

BEGIN;

ALTER TABLE projects_public.project
    ENABLE ROW LEVEL SECURITY;

COMMIT;
