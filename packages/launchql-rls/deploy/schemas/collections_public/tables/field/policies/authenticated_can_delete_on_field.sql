-- Deploy: schemas/collections_public/tables/field/policies/authenticated_can_delete_on_field to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/field/table
-- requires: schemas/collections_public/tables/field/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/field/policies/authenticated_can_update_on_field

BEGIN;
CREATE POLICY authenticated_can_delete_on_field ON collections_public.field FOR DELETE TO authenticated USING ( (SELECT p.owner_id = ANY( "launchql_public".get_current_role_ids() ) FROM collections_public.database AS p WHERE p.id = database_id) );
COMMIT;
