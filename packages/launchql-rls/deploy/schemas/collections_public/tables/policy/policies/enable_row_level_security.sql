-- Deploy: schemas/collections_public/tables/policy/policies/enable_row_level_security to pg
-- made with <3 @ launchql.com

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/policy/table
-- requires: schemas/collections_public/tables/rls_function/grants/authenticated/delete

BEGIN;

ALTER TABLE collections_public.policy
    ENABLE ROW LEVEL SECURITY;
COMMIT;
