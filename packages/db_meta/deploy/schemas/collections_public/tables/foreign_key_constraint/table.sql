-- Deploy schemas/collections_public/tables/foreign_key_constraint/table to pg

-- requires: schemas/collections_public/tables/field/table
-- requires: schemas/collections_public/tables/table/table
-- requires: schemas/collections_public/schema

BEGIN;

CREATE TABLE collections_public.foreign_key_constraint (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
    table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
    name text,
    description text,
    smart_tags jsonb,
    type text,
    field_ids uuid[] NOT NULL,
    ref_table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
    ref_field_ids uuid[] NOT NULL,
    delete_action char(1) DEFAULT 'a',
    update_action char(1) DEFAULT 'a',
    UNIQUE(database_id, name),
    CHECK (field_ids <> '{}'),
    CHECK (ref_field_ids <> '{}')
);

CREATE INDEX foreign_key_constraint_database_id_idx ON collections_public.foreign_key_constraint ( database_id );

COMMIT;
