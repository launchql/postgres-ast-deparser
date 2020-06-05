-- Revert schemas/collections_public/tables/database/alterations/alter_table_add_project_id from pg

BEGIN;

ALTER TABLE collections_public.database
    DROP COLUMN project_id;

COMMIT;
