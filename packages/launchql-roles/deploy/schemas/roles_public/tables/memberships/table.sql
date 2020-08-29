-- Deploy schemas/roles_public/tables/memberships/table to pg
-- requires: schemas/roles_public/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/permissions_public/tables/profile/table

BEGIN;

CREATE TABLE roles_public.memberships (
  id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4 (),
  profile_id uuid NOT NULL REFERENCES permissions_public.profile (id) ON DELETE CASCADE,
  role_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
  group_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
  organization_id uuid NOT NULL REFERENCES roles_public.roles (id) ON DELETE CASCADE,
  invited_by_id uuid NULL REFERENCES roles_public.roles (id),
  inherited boolean not null default false,
  membership_id uuid NULL REFERENCES roles_public.memberships (id) ON DELETE CASCADE,
  UNIQUE (role_id, group_id)
);
COMMENT ON CONSTRAINT memberships_membership_id_fkey ON roles_public.memberships IS E'@fieldName parent';
COMMENT ON COLUMN roles_public.memberships.role_id IS 'the role granted a membership';
COMMENT ON COLUMN roles_public.memberships.group_id IS 'the group that is accessed via this membership';
COMMENT ON COLUMN roles_public.memberships.organization_id IS 'the organization owns the group';

COMMIT;
