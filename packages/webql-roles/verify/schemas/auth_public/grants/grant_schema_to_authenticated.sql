-- Verify schemas/auth_public/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'auth_public', 'USAGE');

ROLLBACK;
