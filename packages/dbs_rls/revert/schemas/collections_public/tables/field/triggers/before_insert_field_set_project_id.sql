-- Revert schemas/collections_public/tables/field/triggers/before_insert_field_set_project_id from pg

BEGIN;

DROP TRIGGER before_insert_field_set_project_id ON collections_public.field;
DROP FUNCTION collections_private.tg_before_insert_field_set_project_id; 

COMMIT;
