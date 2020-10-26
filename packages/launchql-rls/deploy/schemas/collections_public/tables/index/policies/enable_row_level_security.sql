-- Deploy: schemas/collections_public/tables/index/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/index/table
-- requires: schemas/collections_public/tables/full_text_search/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.index
    ENABLE ROW LEVEL SECURITY;
COMMIT;
