-- Deploy: schemas/collections_public/tables/trigger/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger/table
-- requires: schemas/collections_public/tables/trigger/policies/authenticated_can_delete_on_trigger

BEGIN;
GRANT SELECT ON TABLE collections_public.trigger TO authenticated;
COMMIT;
