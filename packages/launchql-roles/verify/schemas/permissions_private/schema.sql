-- Verify schemas/permissions_private/schema  on pg

BEGIN;

SELECT verify_schema ('permissions_private');

ROLLBACK;
