-- Deploy schemas/projects_public/tables/project/indexes/projects_project_name_owner_id_idx to pg

-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project/table

BEGIN;

CREATE UNIQUE INDEX projects_project_name_owner_id_idx ON projects_public.project (
  owner_id,
  name
);

COMMIT;
