-- Revert schemas/collaboration_public/tables/collaboration/policies/enable_row_level_security from pg

BEGIN;

ALTER TABLE collaboration_public.collaboration
    DISABLE ROW LEVEL SECURITY;

COMMIT;
