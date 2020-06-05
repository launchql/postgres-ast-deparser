-- Verify schemas/roles_private/grants/grant_schema_to_anonymous  on pg

BEGIN;

SELECT has_schema_privilege('anonymous', 'roles_private', 'USAGE');

ROLLBACK;
