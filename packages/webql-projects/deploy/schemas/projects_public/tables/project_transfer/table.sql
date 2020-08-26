-- Deploy schemas/projects_public/tables/project_transfer/table to pg

-- requires: schemas/projects_public/schema
-- requires: schemas/projects_public/tables/project/table

BEGIN;

CREATE TABLE projects_public.project_transfer (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  project_id uuid NOT NULL REFERENCES projects_public.project(id) ON DELETE CASCADE,

  current_owner_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,

  new_owner_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,

  accepted boolean NOT NULL DEFAULT FALSE,
  transferred boolean NOT NULL DEFAULT FALSE,
  sender_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,

  transfer_token text NOT NULL DEFAULT encode( gen_random_bytes( 32 ), 'hex' ),
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + interval '1 day'),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(transfer_token)
);

COMMIT;
