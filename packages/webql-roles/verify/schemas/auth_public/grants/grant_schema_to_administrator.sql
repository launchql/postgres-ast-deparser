-- Verify schemas/auth_public/grants/grant_schema_to_administrator  on pg

BEGIN;

SELECT has_schema_privilege('administrator', 'auth_public', 'USAGE');

ROLLBACK;
