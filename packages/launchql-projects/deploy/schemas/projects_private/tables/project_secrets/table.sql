-- Deploy schemas/projects_private/tables/project_secrets/table to pg

-- requires: schemas/projects_private/schema
-- requires: schemas/projects_public/tables/project/table

BEGIN;

CREATE TABLE projects_private.project_secrets (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    project_id uuid REFERENCES projects_public.project ON DELETE CASCADE,
    name text,
    value bytea,
    UNIQUE (project_id, name)
);

COMMIT;
