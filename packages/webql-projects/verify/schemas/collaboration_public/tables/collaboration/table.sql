-- Verify schemas/collaboration_public/tables/collaboration/table on pg

BEGIN;

SELECT verify_table ('collaboration_public.collaboration');

ROLLBACK;
