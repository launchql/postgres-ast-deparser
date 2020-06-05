-- Revert schemas/projects_public/tables/project_transfer/triggers/on_transfer_created from pg

BEGIN;

DROP TRIGGER on_transfer_created ON projects_public.project_transfers;
DROP FUNCTION projects_private.tg_on_transfer_created; 

COMMIT;
