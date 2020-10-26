-- Deploy: schemas/collections_public/tables/full_text_search/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/full_text_search/table
-- requires: schemas/collections_public/tables/foreign_key_constraint/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.full_text_search
    ENABLE ROW LEVEL SECURITY;
COMMIT;
