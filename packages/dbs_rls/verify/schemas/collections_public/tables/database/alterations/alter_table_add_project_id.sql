-- Verify schemas/collections_public/tables/database/alterations/alter_table_add_project_id  on pg

BEGIN;

SELECT project_id FROM collections_public.database LIMIT 1;

ROLLBACK;