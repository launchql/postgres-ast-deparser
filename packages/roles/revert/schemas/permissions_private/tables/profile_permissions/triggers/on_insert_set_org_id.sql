-- Revert schemas/permissions_private/tables/profile_permissions/triggers/on_insert_set_org_id from pg

BEGIN;

DROP TRIGGER on_insert_set_org_id ON permissions_private.profile_permissions;
DROP FUNCTION permissions_private.tg_on_insert_set_org_id; 

COMMIT;
