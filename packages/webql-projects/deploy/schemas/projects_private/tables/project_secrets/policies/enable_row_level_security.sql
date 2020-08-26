-- Deploy schemas/projects_private/tables/project_secrets/policies/enable_row_level_security to pg

-- requires: schemas/projects_private/schema
-- requires: schemas/projects_private/tables/project_secrets/table

BEGIN;

ALTER TABLE projects_private.project_secrets
    ENABLE ROW LEVEL SECURITY;

COMMIT;
