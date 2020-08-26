-- Verify schemas/collaboration_private/schema  on pg

BEGIN;

SELECT verify_schema ('collaboration_private');

ROLLBACK;
