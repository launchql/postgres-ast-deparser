-- Deploy schemas/projects_public/tables/project/table to pg
-- requires: schemas/projects_public/schema

BEGIN;

CREATE TABLE projects_public.project (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4 (),
    name citext NOT NULL CHECK (name ~* '^[a-z0-9_-]{3,255}$'),
    owner_id UUID NOT NULL REFERENCES roles_public.roles (id) DEFAULT roles_public.current_role_id(),
    UNIQUE (owner_id, name)
);

COMMENT ON TABLE projects_public.project IS 'A project is a data structure to manage a project and its resources over time.';

COMMIT;

