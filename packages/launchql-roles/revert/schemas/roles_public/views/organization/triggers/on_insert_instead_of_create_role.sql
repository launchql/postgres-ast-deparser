-- Revert schemas/roles_public/views/organization/triggers/on_insert_instead_of_create_role from pg

BEGIN;

DROP TRIGGER on_insert_instead_of_create_role ON roles_public.roles;
DROP FUNCTION roles_private.tg_on_insert_instead_of_create_role; 

COMMIT;
