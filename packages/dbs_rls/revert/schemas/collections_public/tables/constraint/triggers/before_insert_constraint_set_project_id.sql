-- Revert schemas/collections_public/tables/constraint/triggers/before_insert_constraint_set_project_id from pg

BEGIN;

DROP TRIGGER before_insert_constraint_set_project_id ON collections_public.constraint;
DROP FUNCTION collections_private.tg_before_insert_constraint_set_project_id; 

COMMIT;
