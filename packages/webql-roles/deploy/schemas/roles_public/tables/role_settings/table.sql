-- Deploy schemas/roles_public/tables/role_settings/table to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE TABLE roles_public.role_settings (
    role_id uuid PRIMARY KEY REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    organization_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE
);

COMMIT;
