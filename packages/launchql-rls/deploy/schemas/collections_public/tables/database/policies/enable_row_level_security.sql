-- Deploy: schemas/collections_public/tables/database/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table
-- requires: schemas/launchql_public/tables/organization_profiles/grants/authenticated/select

BEGIN;

ALTER TABLE collections_public.database
    ENABLE ROW LEVEL SECURITY;
COMMIT;
