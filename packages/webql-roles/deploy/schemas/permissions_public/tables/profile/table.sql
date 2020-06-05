-- Deploy schemas/permissions_public/tables/profile/table to pg

-- requires: schemas/permissions_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE TABLE permissions_public.profile (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name text,
    description text,
    organization_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    UNIQUE(organization_id, name)
);

COMMIT;