-- Deploy schemas/collections_public/tables/policy/table to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table

BEGIN;

CREATE TABLE collections_public.policy (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
  database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
  table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
  
  name text,
  role_name text,
  privilege text,

  -- using_expression text,
  -- check_expression text,
  -- policy_text text,

  permissive boolean default true,

  policy_template_name text,
  policy_template_vars json,
  UNIQUE (table_id, name)
);

CREATE INDEX policy_database_id_idx ON collections_public.policy ( database_id );

COMMIT;
