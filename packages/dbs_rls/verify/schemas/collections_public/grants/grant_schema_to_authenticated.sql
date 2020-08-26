-- Verify schemas/collections_public/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'collections_public', 'USAGE');

ROLLBACK;
