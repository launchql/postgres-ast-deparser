-- Revert schemas/collections_public/tables/table/triggers/before_insert_set_project_id from pg

BEGIN;

DROP TRIGGER before_insert_set_project_id ON collections_public.table;
DROP FUNCTION collections_private.tg_before_insert_set_project_id; 

COMMIT;
