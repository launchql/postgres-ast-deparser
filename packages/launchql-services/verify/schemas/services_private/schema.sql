-- Verify schemas/services_private/schema  on pg

BEGIN;

SELECT verify_schema ('services_private');

ROLLBACK;
