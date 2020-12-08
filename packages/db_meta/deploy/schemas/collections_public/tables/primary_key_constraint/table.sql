-- Deploy schemas/collections_public/tables/primary_key_constraint/table to pg

-- requires: schemas/collections_public/schema

BEGIN;

CREATE TABLE collections_public.primary_key_constraint (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
  name text,
  type text,
  field_ids uuid[] NOT NULL,
  UNIQUE(database_id, name),
  CHECK (field_ids <> '{}')
);

COMMIT;
