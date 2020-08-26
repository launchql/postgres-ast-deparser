-- Verify schemas/collections_public/tables/table/alterations/alter_table_add_project_id  on pg

BEGIN;

SELECT project_id FROM collections_public.table LIMIT 1;

ROLLBACK;
