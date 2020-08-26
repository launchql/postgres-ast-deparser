-- Verify schemas/permissions_public/tables/permission/indexes/permission_action_type_object_type_idx  on pg

BEGIN;

SELECT verify_index ('permissions_public.permission', 'permission_action_type_object_type_idx');

ROLLBACK;
