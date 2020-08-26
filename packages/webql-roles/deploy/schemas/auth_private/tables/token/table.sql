-- Deploy schemas/auth_private/tables/token/table to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_private/types/token_type
-- requires: schemas/roles_public/tables/roles/table
-- requires: schemas/auth_private/tables/client/table
-- requires: schemas/auth_public/tables/user_authentications/table

BEGIN;

CREATE TABLE auth_private.token (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    type auth_private.token_type NOT NULL,
    access_token text NOT NULL DEFAULT encode( gen_random_bytes( 48 ), 'hex' ),
    access_token_expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + interval '6 hours'),
    refresh_token text NULL DEFAULT NULL,
    role_id uuid NOT NULL REFERENCES roles_public.roles(id) ON DELETE CASCADE,
    auth_id uuid NULL DEFAULT NULL REFERENCES auth_public.user_authentications(id) ON DELETE CASCADE,
    client_id uuid NULL DEFAULT NULL REFERENCES auth_private.client(id) ON DELETE CASCADE,
    UNIQUE(access_token)

    -- TODO indexes
    -- UNIQUE(refresh_token),
    -- UNIQUE(role_id, auth_id),
    -- UNIQUE(role_id, client_id),
);

COMMENT ON TABLE auth_private.token IS 'Tokens used for authentication';

COMMIT;
