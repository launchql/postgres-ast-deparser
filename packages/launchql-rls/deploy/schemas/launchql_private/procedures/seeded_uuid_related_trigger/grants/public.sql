-- Deploy: schemas/launchql_private/procedures/seeded_uuid_related_trigger/grants/public to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/procedures/seeded_uuid_related_trigger/procedure
-- requires: schemas/launchql_private/procedures/uuid_generate_seeded_uuid/grants/public

BEGIN;

GRANT EXECUTE ON FUNCTION
    "launchql_private".seeded_uuid_related_trigger
TO public;
COMMIT;
