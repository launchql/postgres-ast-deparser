-- Revert schemas/projects_public/tables/project/triggers/on_insert_ensure_proper_owner from pg

BEGIN;

DROP TRIGGER on_insert_ensure_proper_owner ON projects_public.project;
DROP FUNCTION projects_private.tg_on_insert_ensure_proper_owner; 

COMMIT;
