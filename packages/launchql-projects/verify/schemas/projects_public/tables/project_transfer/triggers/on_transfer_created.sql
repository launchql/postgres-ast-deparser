-- Verify schemas/projects_public/tables/project_transfer/triggers/on_transfer_created  on pg

BEGIN;

SELECT verify_function ('projects_private.tg_on_transfer_created', current_user); 
SELECT verify_trigger ('projects_public.on_transfer_created');

ROLLBACK;
