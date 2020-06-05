-- Deploy schemas/permissions_public/tables/permission/indexes/permission_action_type_object_type_idx to pg

-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/permission/table

BEGIN;

CREATE INDEX permission_action_type_object_type_idx ON permissions_public.permission (
 action_type, object_type
);

COMMIT;
