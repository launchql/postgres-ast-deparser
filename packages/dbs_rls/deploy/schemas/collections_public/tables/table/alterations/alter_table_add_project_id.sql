-- Deploy schemas/collections_public/tables/table/alterations/alter_table_add_project_id to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table/table

BEGIN;

ALTER TABLE collections_public.table
    ADD COLUMN project_id uuid NOT NULL;

COMMIT;
