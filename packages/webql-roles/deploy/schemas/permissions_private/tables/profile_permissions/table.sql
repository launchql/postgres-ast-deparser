-- Deploy schemas/permissions_private/tables/profile_permissions/table to pg

-- requires: schemas/roles_public/tables/roles/table

-- requires: schemas/permissions_private/schema
-- requires: schemas/permissions_public/tables/profile/table
-- requires: schemas/permissions_public/tables/permission/table

BEGIN;

CREATE TABLE permissions_private.profile_permissions (
    profile_id uuid NOT NULL REFERENCES permissions_public.profile (id) ON DELETE CASCADE,
    permission_id uuid NOT NULL REFERENCES permissions_public.permission (id) ON DELETE CASCADE,
    organization_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
    PRIMARY KEY (profile_id, permission_id)
);

COMMIT;