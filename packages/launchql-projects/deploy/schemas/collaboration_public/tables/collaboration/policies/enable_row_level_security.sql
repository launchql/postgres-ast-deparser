-- Deploy schemas/collaboration_public/tables/collaboration/policies/enable_row_level_security to pg

-- requires: schemas/collaboration_public/schema
-- requires: schemas/collaboration_public/tables/collaboration/table

BEGIN;

ALTER TABLE collaboration_public.collaboration
    ENABLE ROW LEVEL SECURITY;

COMMIT;
