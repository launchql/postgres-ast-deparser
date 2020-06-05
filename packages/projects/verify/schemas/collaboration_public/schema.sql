-- Verify schemas/collaboration_public/schema  on pg

BEGIN;

SELECT verify_schema ('collaboration_public');

ROLLBACK;
