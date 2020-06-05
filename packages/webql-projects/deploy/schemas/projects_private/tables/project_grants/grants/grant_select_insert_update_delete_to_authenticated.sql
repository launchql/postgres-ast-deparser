-- Deploy schemas/projects_private/tables/project_grants/grants/grant_select_insert_update_delete_to_authenticated to pg

-- requires: schemas/projects_private/schema
-- requires: schemas/projects_private/tables/project_grants/table

BEGIN;

-- TODO make sure to require any policies on this table!

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE projects_private.project_grants TO authenticated;

COMMIT;
