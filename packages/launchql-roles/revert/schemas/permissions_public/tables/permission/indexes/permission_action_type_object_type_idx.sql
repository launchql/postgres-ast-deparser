-- Revert schemas/permissions_public/tables/permission/indexes/permission_action_type_object_type_idx from pg

BEGIN;

DROP INDEX permissions_public.permission_action_type_object_type_idx;

COMMIT;
