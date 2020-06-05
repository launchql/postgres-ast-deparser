-- Revert schemas/roles_public/tables/memberships/triggers/on_create_cascade_hierarchy from pg

BEGIN;

DROP TRIGGER on_create_cascade_hierarchy ON roles_public.memberships;
DROP FUNCTION roles_private.tg_on_create_cascade_hierarchy; 

COMMIT;
