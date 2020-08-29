-- Deploy schemas/auth_private/tables/user_authentication_secrets/table to pg

-- requires: schemas/auth_private/schema
-- requires: schemas/auth_public/tables/user_authentications/table

BEGIN;

CREATE TABLE auth_private.user_authentication_secrets (
  user_authentication_id uuid NOT NULL PRIMARY KEY REFERENCES auth_public.user_authentications ON DELETE CASCADE,
  details jsonb NOT NULL DEFAULT '{}'::jsonb
);

COMMIT;
