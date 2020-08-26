-- Revert schemas/collections_public/tables/field/alterations/alter_table_add_project_id from pg

BEGIN;

ALTER TABLE collections_public.field
    DROP COLUMN project_id;

COMMIT;
