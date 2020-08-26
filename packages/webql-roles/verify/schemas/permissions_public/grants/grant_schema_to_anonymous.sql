-- Verify schemas/permissions_public/grants/grant_schema_to_anonymous  on pg

BEGIN;

SELECT has_schema_privilege('anonymous', 'permissions_public', 'USAGE');

ROLLBACK;
