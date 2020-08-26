-- Verify schemas/roles_public/grants/grant_schema_to_administrator  on pg

BEGIN;

SELECT has_schema_privilege('administrator', 'roles_public', 'USAGE');

ROLLBACK;
