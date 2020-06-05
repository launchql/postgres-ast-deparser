-- Verify schemas/auth_public/grants/grant_schema_to_anonymous  on pg

BEGIN;

SELECT has_schema_privilege('anonymous', 'auth_public', 'USAGE');

ROLLBACK;
