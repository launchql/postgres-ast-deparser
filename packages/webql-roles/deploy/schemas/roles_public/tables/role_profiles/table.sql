-- Deploy schemas/roles_public/tables/role_profiles/table to pg

-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE TABLE roles_public.role_profiles (
    role_id uuid PRIMARY KEY REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    organization_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,

    display_name text NULL,
    avatar_url text CHECK (avatar_url ~ '^https?://[^/]+'), -- username only for orgs, users

    bio text NULL,
    url text NULL,
    company text NULL,
    location text NULL
);

COMMIT;
