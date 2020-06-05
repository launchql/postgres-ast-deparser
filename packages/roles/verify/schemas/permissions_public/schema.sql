-- Verify schemas/permissions_public/schema  on pg

BEGIN;

SELECT verify_schema ('permissions_public');

ROLLBACK;
