-- Verify schemas/roles_public/grants/grant_schema_to_anonymous_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('anonymous', 'roles_public', 'USAGE');
SELECT has_schema_privilege('authenticated', 'roles_public', 'USAGE');

ROLLBACK;
