-- Revert schemas/collaboration_public/tables/collaboration/table from pg

BEGIN;

DROP TABLE collaboration_public.collaboration;

COMMIT;
