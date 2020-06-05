-- Verify schemas/auth_private/grants/grant_schema_to_anonymous  on pg

BEGIN;

SELECT has_schema_privilege('anonymous', 'auth_private', 'USAGE');

ROLLBACK;
