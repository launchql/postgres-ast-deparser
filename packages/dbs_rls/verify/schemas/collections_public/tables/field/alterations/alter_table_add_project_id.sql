-- Verify schemas/collections_public/tables/field/alterations/alter_table_add_project_id  on pg

BEGIN;

SELECT project_id FROM collections_public.field LIMIT 1;

ROLLBACK;
