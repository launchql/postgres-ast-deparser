-- Deploy schemas/collections_public/tables/check_constraint/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table 
-- requires: schemas/collections_public/tables/table/table 

BEGIN;

CREATE TABLE collections_public.check_constraint (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
  name text,
  type text,
  field_ids uuid[] NOT NULL,
  expr jsonb,
  UNIQUE (database_id, name),
  CHECK (field_ids <> '{}')
);

CREATE INDEX check_constraint_database_id_idx ON collections_public.check_constraint ( database_id );

COMMIT;
