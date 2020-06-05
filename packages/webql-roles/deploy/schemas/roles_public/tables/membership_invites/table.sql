-- Deploy schemas/roles_public/tables/membership_invites/table to pg

-- requires: schemas/roles_private/schema
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/permissions_public/tables/profile/table

BEGIN;

CREATE TABLE roles_public.membership_invites (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  profile_id uuid NOT NULL REFERENCES permissions_public.profile (id) ON DELETE CASCADE,
  role_id uuid NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,
  email email NULL,
  approved boolean NOT NULL DEFAULT FALSE,
  accepted boolean NOT NULL DEFAULT FALSE,
  group_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,
  organization_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,
  invite_token text NOT NULL DEFAULT encode( gen_random_bytes( 32 ), 'hex' ),
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + interval '1 week'),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(invite_token)
);

COMMENT ON COLUMN roles_public.membership_invites.invite_token IS '@omit';

COMMIT;