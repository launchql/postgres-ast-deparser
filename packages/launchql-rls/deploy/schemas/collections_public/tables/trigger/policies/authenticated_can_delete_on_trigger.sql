-- Deploy: schemas/collections_public/tables/trigger/policies/authenticated_can_delete_on_trigger to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger/table
-- requires: schemas/collections_public/tables/trigger/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/trigger/policies/authenticated_can_update_on_trigger

BEGIN;
CREATE POLICY authenticated_can_delete_on_trigger ON collections_public.trigger FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY( "launchql_public".get_current_role_ids() ) FROM collections_public.database AS p WHERE p.id = database_id) );
COMMIT;
