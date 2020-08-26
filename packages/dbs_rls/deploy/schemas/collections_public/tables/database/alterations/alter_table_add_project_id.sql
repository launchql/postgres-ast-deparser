-- Deploy schemas/collections_public/tables/database/alterations/alter_table_add_project_id to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table

BEGIN;

ALTER TABLE collections_public.database
    ADD COLUMN project_id uuid NOT NULL;

COMMIT;
