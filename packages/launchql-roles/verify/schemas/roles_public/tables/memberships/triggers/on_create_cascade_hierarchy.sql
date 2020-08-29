-- Verify schemas/roles_public/tables/memberships/triggers/on_create_cascade_hierarchy  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_create_cascade_hierarchy'); 
SELECT verify_trigger ('roles_public.on_create_cascade_hierarchy');

ROLLBACK;
