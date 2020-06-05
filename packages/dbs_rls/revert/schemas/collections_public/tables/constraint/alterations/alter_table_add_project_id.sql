-- Revert schemas/collections_public/tables/constraint/alterations/alter_table_add_project_id from pg

BEGIN;

ALTER TABLE collections_public.constraint
    DROP COLUMN project_id;

COMMIT;
