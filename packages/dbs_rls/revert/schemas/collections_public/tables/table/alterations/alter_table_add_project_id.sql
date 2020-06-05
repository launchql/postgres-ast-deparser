-- Revert schemas/collections_public/tables/table/alterations/alter_table_add_project_id from pg

BEGIN;

ALTER TABLE collections_public.table
    DROP COLUMN project_id;

COMMIT;
