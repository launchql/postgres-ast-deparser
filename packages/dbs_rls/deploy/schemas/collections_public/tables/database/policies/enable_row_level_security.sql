-- Deploy schemas/collections_public/tables/database/policies/enable_row_level_security to pg

-- requires: schemas/collections_public/schema
-- requires: schemas/collections_public/tables/database/table

BEGIN;

ALTER TABLE collections_public.database
    ENABLE ROW LEVEL SECURITY;

COMMIT;
