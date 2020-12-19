-- Deploy schemas/meta_public/tables/default_ids_module/table to pg

-- requires: schemas/meta_public/schema

BEGIN;

CREATE TABLE meta_public.default_ids_module (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4 ()
);

COMMIT;
