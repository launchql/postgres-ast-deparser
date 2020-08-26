-- Verify schemas/permissions_private/tables/profile_permissions/triggers/on_insert_set_org_id  on pg

BEGIN;

SELECT verify_function ('permissions_private.tg_on_insert_set_org_id'); 
SELECT verify_trigger ('permissions_private.on_insert_set_org_id');

ROLLBACK;
