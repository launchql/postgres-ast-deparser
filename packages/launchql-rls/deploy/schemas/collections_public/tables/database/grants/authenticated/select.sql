-- Deploy: schemas/collections_public/tables/database/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/collections_public/tables/database/policies/authenticated_can_delete_on_database

BEGIN;
GRANT SELECT ON TABLE collections_public.database TO authenticated;
COMMIT;
