-- Verify schemas/auth_public/schema  on pg

BEGIN;

SELECT
    verify_schema ('auth_public');

ROLLBACK;
