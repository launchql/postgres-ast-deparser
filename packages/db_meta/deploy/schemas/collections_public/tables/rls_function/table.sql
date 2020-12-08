-- Deploy schemas/collections_public/tables/rls_function/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table

BEGIN;

CREATE TABLE collections_public.rls_function (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  name text NOT NULL,

  function_template_name text,
  function_template_vars json,
  label text,
  description text,
  UNIQUE(function_template_name, database_id),
  UNIQUE (database_id, name)
);

COMMIT;
