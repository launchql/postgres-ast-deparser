-- Revert schemas/collaboration_public/tables/collaboration/indexes/collaboration_role_id_idx from pg

BEGIN;

DROP INDEX collaboration_public.collaboration_role_id_idx;

COMMIT;
