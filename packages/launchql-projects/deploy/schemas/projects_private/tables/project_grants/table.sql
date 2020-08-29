-- Deploy schemas/projects_private/tables/project_grants/table to pg

-- requires: schemas/projects_public/tables/project/table
-- requires: schemas/projects_private/schema

BEGIN;

CREATE TABLE projects_private.project_grants (
  role_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,
  proj_id uuid NOT NULL REFERENCES projects_public.project(id) ON DELETE CASCADE,
  PRIMARY KEY(role_id, proj_id)
);


COMMIT;
