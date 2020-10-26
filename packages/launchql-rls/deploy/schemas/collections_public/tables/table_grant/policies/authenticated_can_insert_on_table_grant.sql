-- Deploy: schemas/collections_public/tables/table_grant/policies/authenticated_can_insert_on_table_grant to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/table_grant/table
-- requires: schemas/collections_public/tables/table_grant/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/table_grant/policies/authenticated_can_select_on_table_grant

BEGIN;
CREATE POLICY authenticated_can_insert_on_table_grant ON collections_public.table_grant FOR INSERT TO authenticated WITH CHECK ( (SELECT p.owner_id = ANY( "launchql_public".get_current_role_ids() ) FROM collections_public.database AS p WHERE p.id = database_id) );
COMMIT;
