-- Deploy schemas/files_public/tables/buckets/table to pg
-- requires: schemas/files_public/schema

BEGIN;
CREATE TABLE files_public.buckets (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  name text,
  exists boolean NOT NULL DEFAULT FALSE,
  type varchar(255) NOT NULL DEFAULT 'uploads',
  owner_id UUID NOT NULL REFERENCES roles_public.roles (id),
  organization_id UUID NOT NULL REFERENCES roles_public.roles (id),
  UNIQUE (owner_id, type)
);

COMMENT ON COLUMN files_public.buckets.name IS E'@omit';
COMMENT ON COLUMN files_public.buckets.exists IS E'@omit';

COMMIT;

