-- Verify schemas/services_public/schema  on pg

BEGIN;

SELECT verify_schema ('services_public');

ROLLBACK;
