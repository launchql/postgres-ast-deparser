-- Deploy schemas/roles_public/tables/roles/table to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/types/role_type

BEGIN;

CREATE TABLE roles_public.roles (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  TYPE roles_public.role_type NOT NULL,
  username citext NULL,

  parent_id uuid NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
  organization_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE
);

COMMENT ON TABLE roles_public.roles IS 'A user of the forum.';

COMMENT ON COLUMN roles_public.roles.username IS 'Unique username.';

-- parent_id only for teams
-- organization_id = id for orgs and users
COMMENT ON COLUMN roles_public.roles.parent_id IS 'A Team role has a parent.';
COMMENT ON COLUMN roles_public.roles.organization_id IS 'A Team role has an owner.';

COMMIT;

