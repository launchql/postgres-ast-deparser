-- Revert schemas/roles_public/tables/memberships/triggers/on_create_inherit_profile_if_null from pg

BEGIN;

DROP TRIGGER on_create_inherit_profile_if_null ON roles_public.memberships;
DROP FUNCTION roles_private.tg_on_create_inherit_profile_if_null; 

COMMIT;
