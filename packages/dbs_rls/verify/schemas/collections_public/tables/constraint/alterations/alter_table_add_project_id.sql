-- Verify schemas/collections_public/tables/constraint/alterations/alter_table_add_project_id  on pg

BEGIN;

SELECT project_id FROM collections_public.constraint LIMIT 1;

ROLLBACK;
