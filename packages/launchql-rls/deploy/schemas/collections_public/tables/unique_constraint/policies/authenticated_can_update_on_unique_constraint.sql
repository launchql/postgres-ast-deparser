-- Deploy: schemas/collections_public/tables/unique_constraint/policies/authenticated_can_update_on_unique_constraint to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/unique_constraint/table
-- requires: schemas/collections_public/tables/unique_constraint/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/unique_constraint/policies/authenticated_can_insert_on_unique_constraint

BEGIN;
CREATE POLICY authenticated_can_update_on_unique_constraint ON collections_public.unique_constraint FOR UPDATE TO authenticated USING ( (SELECT p.owner_id = ANY( "launchql_public".get_current_role_ids() ) FROM collections_public.database AS p WHERE p.id = database_id) );
COMMIT;
