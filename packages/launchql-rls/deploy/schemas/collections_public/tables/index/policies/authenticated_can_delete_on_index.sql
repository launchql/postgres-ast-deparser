-- Deploy: schemas/collections_public/tables/index/policies/authenticated_can_delete_on_index to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/index/table
-- requires: schemas/collections_public/tables/index/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/index/policies/authenticated_can_update_on_index

BEGIN;
CREATE POLICY authenticated_can_delete_on_index ON collections_public.index FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY( "launchql_public".get_current_role_ids() ) FROM collections_public.database AS p WHERE p.id = database_id) );
COMMIT;
