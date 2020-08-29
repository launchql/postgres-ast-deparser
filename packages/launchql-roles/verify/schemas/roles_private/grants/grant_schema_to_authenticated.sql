-- Verify schemas/roles_private/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'roles_private', 'USAGE');

ROLLBACK;
