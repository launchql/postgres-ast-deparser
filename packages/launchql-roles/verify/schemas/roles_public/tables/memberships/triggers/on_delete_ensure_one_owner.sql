-- Verify schemas/roles_public/tables/memberships/triggers/on_delete_ensure_one_owner  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_delete_ensure_one_owner'); 
SELECT verify_trigger ('roles_public.on_delete_ensure_one_owner');

ROLLBACK;
