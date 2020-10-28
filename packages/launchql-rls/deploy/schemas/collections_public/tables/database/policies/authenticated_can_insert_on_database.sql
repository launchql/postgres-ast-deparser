-- Deploy: schemas/collections_public/tables/database/policies/authenticated_can_insert_on_database to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/collections_public/tables/database/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/database/policies/authenticated_can_select_on_database

BEGIN;
CREATE POLICY authenticated_can_insert_on_database ON collections_public.database FOR INSERT TO authenticated WITH CHECK ( owner_id = "launchql_public".get_current_user_id() );
COMMIT;