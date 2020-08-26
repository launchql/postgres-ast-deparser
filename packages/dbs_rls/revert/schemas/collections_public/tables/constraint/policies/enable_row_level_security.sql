-- Revert schemas/collections_public/tables/constraint/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE collections_public.constraint
    DISABLE ROW LEVEL SECURITY;

COMMIT;
