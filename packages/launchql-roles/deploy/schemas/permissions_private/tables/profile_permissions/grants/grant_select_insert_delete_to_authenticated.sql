-- Deploy schemas/permissions_private/tables/profile_permissions/grants/grant_select_insert_delete_to_authenticated to pg

-- requires: schemas/permissions_private/schema
-- requires: schemas/permissions_private/tables/profile_permissions/table

BEGIN;

-- NOTE: never move this to public without updating POLICY!
-- THIS IS A PRIVATE JOIN TABLE 

GRANT SELECT, INSERT, DELETE ON TABLE permissions_private.profile_permissions TO authenticated;

COMMIT;
