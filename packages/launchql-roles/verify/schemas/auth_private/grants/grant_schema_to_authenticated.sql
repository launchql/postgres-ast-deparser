-- Verify schemas/auth_private/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'auth_private', 'USAGE');

ROLLBACK;
