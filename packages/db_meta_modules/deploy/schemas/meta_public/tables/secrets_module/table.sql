-- Deploy schemas/meta_public/tables/secrets_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.secrets_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 ()
  -- fields
);

COMMENT ON TABLE meta_public.secrets_module IS 'A comment.';

COMMENT ON COLUMN meta_public.secrets_module.id IS 'The primary unique identifier for the secrets_module table.';

COMMIT;
