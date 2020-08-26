-- Verify schemas/collaboration_public/tables/collaboration/indexes/collaboration_collaboration_id_idx  on pg

BEGIN;

SELECT verify_index ('collaboration_public.collaboration', 'collaboration_collaboration_id_idx');

ROLLBACK;
