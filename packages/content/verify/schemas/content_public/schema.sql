-- Verify schemas/content_public/schema  on pg

BEGIN;

SELECT verify_schema ('content_public');

ROLLBACK;
