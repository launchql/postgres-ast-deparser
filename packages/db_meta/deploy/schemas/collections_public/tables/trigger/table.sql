-- Deploy schemas/collections_public/tables/trigger/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table

BEGIN;

-- https://www.postgresql.org/docs/12/sql-createtrigger.html

CREATE TABLE collections_public.trigger (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
  name text NOT NULL,
  event text, -- INSERT, UPDATE, DELETE, or TRUNCATE
  function_name text,
  UNIQUE(table_id, name)
);

CREATE INDEX trigger_database_id_idx ON collections_public.trigger ( database_id );

COMMIT;
