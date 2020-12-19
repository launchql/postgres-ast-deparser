-- Deploy schemas/meta_public/tables/tokens_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.tokens_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 (),
    schema_id uuid NOT NULL
);

COMMIT;
