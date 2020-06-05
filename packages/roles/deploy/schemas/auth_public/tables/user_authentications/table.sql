-- Deploy schemas/auth_public/tables/user_authentications/table to pg

-- requires: schemas/auth_public/schema

BEGIN;

CREATE TABLE auth_public.user_authentications (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  role_id uuid NOT NULL REFERENCES roles_public.roles ON DELETE CASCADE,
  service text NOT NULL,
  identifier text NOT NULL,
  details jsonb NOT NULL DEFAULT '{}'::jsonb,
  constraint uniq_user_authentications UNIQUE(service, identifier)
);

COMMENT ON TABLE auth_public.user_authentications IS
  E'@omit all\nContains information about the login providers this user has used, so that they may disconnect them should they wish.';
COMMENT ON COLUMN auth_public.user_authentications.role_id IS
  E'@omit';
COMMENT ON COLUMN auth_public.user_authentications.service IS
  E'The login service used, e.g. `twitter` or `github`.';
COMMENT ON COLUMN auth_public.user_authentications.identifier IS
  E'A unique identifier for the user within the login service.';
COMMENT ON COLUMN auth_public.user_authentications.details IS
  E'@omit\nAdditional profile details extracted from this login method';

COMMIT;
