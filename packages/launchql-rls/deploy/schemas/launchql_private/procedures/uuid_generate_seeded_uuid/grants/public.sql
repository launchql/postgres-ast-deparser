-- Deploy: schemas/launchql_private/procedures/uuid_generate_seeded_uuid/grants/public to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_private/procedures/uuid_generate_v4/grants/public
-- requires: schemas/launchql_private/procedures/uuid_generate_seeded_uuid/procedure

BEGIN;

GRANT EXECUTE ON FUNCTION
    "launchql_private".uuid_generate_seeded_uuid
TO public;
COMMIT;
