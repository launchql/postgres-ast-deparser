-- Verify schemas/status_public/procedures/tasks_required_for  on pg

BEGIN;

SELECT verify_function ('status_public.tasks_required_for');

ROLLBACK;
