-- Revert schemas/collections_public/tables/database/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE collections_public.database
    DISABLE ROW LEVEL SECURITY;

COMMIT;
