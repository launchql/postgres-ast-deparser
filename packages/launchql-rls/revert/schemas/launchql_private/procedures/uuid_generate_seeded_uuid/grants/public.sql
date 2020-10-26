-- Revert: schemas/launchql_private/procedures/uuid_generate_seeded_uuid/grants/public from pg

BEGIN;


REVOKE EXECUTE ON FUNCTION
    "launchql_rls_private".uuid_generate_seeded_uuid
FROM public;
COMMIT;  

