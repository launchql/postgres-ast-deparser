-- Revert schemas/collaboration_public/tables/collaboration/indexes/collaboration_collaboration_id_idx from pg

BEGIN;

DROP INDEX collaboration_public.collaboration_collaboration_id_idx;

COMMIT;
