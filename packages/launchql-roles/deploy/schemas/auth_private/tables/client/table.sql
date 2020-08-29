-- Deploy schemas/auth_private/tables/client/table to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/roles_public/tables/roles/table

BEGIN;

CREATE TABLE auth_private.client (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    label text NOT NULL,
    -- service text NOT NULL,
    api_key text NOT NULL DEFAULT encode( gen_random_bytes( 24 ), 'hex' ),
    secret_key text NOT NULL DEFAULT encode( gen_random_bytes( 48 ), 'hex' ),
    role_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE
);

COMMIT;
