-- Verify schemas/collections_private/grants/grant_schema_to_authenticated  on pg

BEGIN;

SELECT has_schema_privilege('authenticated', 'collections_private', 'USAGE');

ROLLBACK;
