-- Deploy schemas/permissions_public/tables/permission/grants/grant_select_to_authenticated to pg

-- requires: schemas/permissions_public/schema
-- requires: schemas/permissions_public/tables/permission/table

BEGIN;

-- TODO make sure to require any policies on this table!

GRANT SELECT ON TABLE permissions_public.permission TO authenticated;

COMMIT;
