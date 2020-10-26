-- Deploy: schemas/collections_public/tables/full_text_search/grants/authenticated/select to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/full_text_search/table
-- requires: schemas/collections_public/tables/full_text_search/policies/authenticated_can_delete_on_full_text_search

BEGIN;
GRANT SELECT ON TABLE collections_public.full_text_search TO authenticated;
COMMIT;
