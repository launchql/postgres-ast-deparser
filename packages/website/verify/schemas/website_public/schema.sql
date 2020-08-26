-- Verify schemas/website_public/schema  on pg

BEGIN;

SELECT verify_schema ('website_public');

ROLLBACK;
