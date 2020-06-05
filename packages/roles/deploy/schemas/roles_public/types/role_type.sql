-- Deploy schemas/roles_public/types/role_type to pg

-- requires: schemas/roles_public/schema

BEGIN;

CREATE TYPE roles_public.role_type AS ENUM (
  'Organization',
  'Team',
  'User'
);

COMMIT;
