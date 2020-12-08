-- Deploy schemas/collections_public/tables/table/table to pg
-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/collections_public/tables/schema/table

BEGIN;
CREATE TABLE collections_public.table (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  schema_id uuid NOT NULL REFERENCES collections_public.schema (id) ON DELETE CASCADE,
  
  name text NOT NULL,
  description text,
  smart_tags jsonb,
  
  is_system boolean DEFAULT FALSE, -- TODO DEPRECATE
  use_rls boolean NOT NULL DEFAULT FALSE,

  plural_name text,
  singular_name text,

  
  UNIQUE (database_id, name)
);

ALTER TABLE collections_public.table ADD COLUMN
    inherits_id uuid NULL REFERENCES collections_public.table(id);

COMMIT;

