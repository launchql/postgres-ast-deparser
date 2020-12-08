-- Deploy schemas/collections_public/tables/index/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table
-- requires: schemas/collections_public/tables/database/table

BEGIN;

CREATE TABLE collections_public.index (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
  name text NOT NULL,
  field_ids uuid[],

  -- index names are UNIQUE across schemas, so for portability we will check against database_id
  UNIQUE (database_id, name)
);

CREATE INDEX index_database_id_idx ON collections_public.index ( database_id );

COMMIT;
