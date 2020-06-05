-- Verify schemas/roles_public/tables/memberships/triggers/on_create_inherit_profile_if_null  on pg

BEGIN;

SELECT verify_function ('roles_private.tg_on_create_inherit_profile_if_null'); 
SELECT verify_trigger ('roles_public.on_create_inherit_profile_if_null');

ROLLBACK;
