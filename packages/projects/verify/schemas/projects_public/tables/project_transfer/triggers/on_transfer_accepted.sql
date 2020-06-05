-- Verify schemas/projects_public/tables/project_transfer/triggers/on_transfer_accepted  on pg

BEGIN;

SELECT verify_function ('projects_private.tg_on_transfer_accepted', current_user); 
SELECT verify_trigger ('projects_public.on_transfer_accepted');

ROLLBACK;
