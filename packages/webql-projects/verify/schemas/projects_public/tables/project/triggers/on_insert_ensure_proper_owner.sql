-- Verify schemas/projects_public/tables/project/triggers/on_insert_ensure_proper_owner  on pg

BEGIN;

SELECT verify_function ('projects_private.tg_on_insert_ensure_proper_owner'); 
SELECT verify_trigger ('projects_public.on_insert_ensure_proper_owner');

ROLLBACK;
