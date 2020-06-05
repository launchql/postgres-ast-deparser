-- Revert schemas/roles_public/tables/memberships/triggers/on_delete_ensure_one_owner from pg

BEGIN;

DROP TRIGGER on_delete_ensure_one_owner ON roles_public.memberships;
DROP FUNCTION roles_private.tg_on_delete_ensure_one_owner; 

COMMIT;
