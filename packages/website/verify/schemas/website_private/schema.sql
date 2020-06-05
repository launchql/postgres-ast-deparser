-- Verify schemas/website_private/schema  on pg

BEGIN;

SELECT verify_schema ('website_private');

ROLLBACK;
