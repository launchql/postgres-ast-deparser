-- Deploy schemas/collections_public/tables/full_text_search/table to pg

-- requires: schemas/collections_public/schema

BEGIN;

CREATE TABLE collections_public.full_text_search (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    database_id uuid NOT NULL REFERENCES collections_public.database (id) ON DELETE CASCADE,
    table_id uuid NOT NULL REFERENCES collections_public.table (id) ON DELETE CASCADE,
    field_id uuid NOT NULL,
    field_ids uuid[] NOT NULL,
    weights text[] NOT NULL,
    langs text[] NOT NULL,
    CHECK (cardinality(field_ids) = cardinality(weights) AND cardinality(weights) = cardinality(langs))
);

COMMIT;
