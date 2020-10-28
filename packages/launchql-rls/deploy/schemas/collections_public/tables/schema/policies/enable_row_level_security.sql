-- Deploy: schemas/collections_public/tables/schema/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/schema/table
-- requires: schemas/collections_public/tables/database/grants/authenticated/delete
-- requires: schemas/launchql_public/procedures/get_current_user_id/procedure 

BEGIN;

ALTER TABLE collections_public.schema
    ENABLE ROW LEVEL SECURITY;
COMMIT;