-- Deploy schemas/roles_public/tables/invites/table to pg

-- requires: schemas/roles_public/schema

BEGIN;

CREATE TABLE roles_public.invites (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  email email NULL,
  sender_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE DEFAULT roles_public.current_role_id(),
  invite_token text NOT NULL DEFAULT encode( gen_random_bytes( 32 ), 'hex' ),
  invite_used boolean NOT NULL DEFAULT FALSE,
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + interval '12 months'),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(email, sender_id),
  UNIQUE(invite_token)
);

COMMENT ON COLUMN roles_public.invites.invite_token IS '@omit';

COMMIT;
