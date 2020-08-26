-- Verify schemas/files_private/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'files_private', 'USAGE');

ROLLBACK;
