-- Verify schemas/collections_public/tables/primary_key_constraint/triggers/before_insert_pkey_constraint_set_project_id  on pg

BEGIN;

SELECT verify_function ('collections_private.tg_before_insert_pkey_constraint_set_project_id'); 
SELECT verify_trigger ('collections_public.before_insert_pkey_constraint_set_project_id');

ROLLBACK;
