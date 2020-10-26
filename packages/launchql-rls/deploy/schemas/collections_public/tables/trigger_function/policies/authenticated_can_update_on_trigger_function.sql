-- Deploy: schemas/collections_public/tables/trigger_function/policies/authenticated_can_update_on_trigger_function to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/trigger_function/table
-- requires: schemas/collections_public/tables/trigger_function/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/trigger_function/policies/authenticated_can_insert_on_trigger_function

BEGIN;
CREATE POLICY authenticated_can_update_on_trigger_function ON collections_public.trigger_function FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY( "launchql_public".get_current_role_ids() ) FROM collections_public.database AS p WHERE p.id = database_id) );
COMMIT;
