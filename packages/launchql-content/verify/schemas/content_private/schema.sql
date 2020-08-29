-- Verify schemas/content_private/schema  on pg

BEGIN;

SELECT verify_schema ('content_private');

ROLLBACK;
