-- Revert schemas/status_public/procedures/tasks_required_for from pg

BEGIN;

DROP FUNCTION status_public.tasks_required_for;

COMMIT;
