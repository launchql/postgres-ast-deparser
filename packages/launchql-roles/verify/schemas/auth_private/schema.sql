-- Verify schemas/auth_private/schema  on pg

BEGIN;

SELECT verify_schema ('auth_private');

ROLLBACK;
