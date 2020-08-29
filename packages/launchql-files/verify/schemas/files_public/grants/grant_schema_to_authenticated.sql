-- Verify schemas/files_public/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'files_public', 'USAGE');

ROLLBACK;
