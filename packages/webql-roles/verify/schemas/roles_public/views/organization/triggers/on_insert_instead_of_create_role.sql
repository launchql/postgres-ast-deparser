-- Verify schemas/roles_public/views/organization/triggers/on_insert_instead_of_create_role  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_insert_instead_of_create_role'); 
SELECT verify_trigger ('roles_public.on_insert_instead_of_create_role');

ROLLBACK;
