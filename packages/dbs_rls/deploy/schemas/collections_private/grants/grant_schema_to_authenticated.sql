-- Deploy schemas/collections_private/grants/grant_schema_to_authenticated to pg

-- requires: schemas/collections_private/schema

BEGIN;

GRANT USAGE ON SCHEMA collections_private
TO authenticated, anonymous;

GRANT EXECUTE ON FUNCTION 
collections_private.get_available_schema_name 
TO
authenticated;
GRANT EXECUTE ON FUNCTION 
collections_private.database_name_hash 
TO
authenticated;


-- ALTER DEFAULT PRIVILEGES IN SCHEMA permissions_private
-- GRANT EXECUTE ON FUNCTIONS
-- TO authenticated;

COMMIT;
