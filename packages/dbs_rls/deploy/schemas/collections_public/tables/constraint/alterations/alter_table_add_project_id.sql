-- Deploy schemas/collections_public/tables/constraint/alterations/alter_table_add_project_id to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/constraint/table

BEGIN;

ALTER TABLE collections_public.constraint
    ADD COLUMN project_id uuid NOT NULL;

COMMIT;
