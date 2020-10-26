-- Deploy: schemas/launchql_private/procedures/uuid_generate_v4/grants/public to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/procedures/uuid_generate_v4/procedure
-- requires: schemas/launchql_private/procedures/seeded_uuid_related_trigger/procedure

BEGIN;

GRANT EXECUTE ON FUNCTION
    "launchql_private".uuid_generate_v4
TO public;
COMMIT;
