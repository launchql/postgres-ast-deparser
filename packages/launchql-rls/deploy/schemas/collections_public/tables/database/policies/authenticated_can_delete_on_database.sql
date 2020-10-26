-- Deploy: schemas/collections_public/tables/database/policies/authenticated_can_delete_on_database to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/collections_public/tables/database/policies/enable_row_level_security
-- requires: schemas/collections_public/tables/database/policies/authenticated_can_update_on_database

BEGIN;
CREATE POLICY authenticated_can_delete_on_database ON collections_public.database FOR DELETE TO authenticated USING ( owner_id = "launchql_public".get_current_user_id() );
COMMIT;
