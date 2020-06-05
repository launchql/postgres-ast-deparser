-- Deploy schemas/collections_public/tables/field/alterations/alter_table_add_project_id to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/field/table

BEGIN;

ALTER TABLE collections_public.field
    ADD COLUMN project_id uuid NOT NULL;

COMMIT;
