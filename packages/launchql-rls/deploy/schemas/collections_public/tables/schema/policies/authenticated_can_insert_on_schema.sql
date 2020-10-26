-- Deploy: schemas/collections_public/tables/schema/policies/authenticated_can_insert_on_schema to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema/table
-- requires: schemas/collections_public/tables/schema/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/schema/policies/authenticated_can_select_on_schema

BEGIN;
CREATE POLICY authenticated_can_insert_on_schema ON collections_public.schema FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY( "launchql_public".get_current_role_ids() ) FROM collections_public.database AS p WHERE p.id = database_id) );
COMMIT;
