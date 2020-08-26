-- Verify schemas/permissions_public/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'permissions_public', 'USAGE');

ROLLBACK;
