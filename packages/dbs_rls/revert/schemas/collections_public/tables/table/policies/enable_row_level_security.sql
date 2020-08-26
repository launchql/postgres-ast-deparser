-- Revert schemas/collections_public/tables/table/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE collections_public.table
    DISABLE ROW LEVEL SECURITY;

COMMIT;
