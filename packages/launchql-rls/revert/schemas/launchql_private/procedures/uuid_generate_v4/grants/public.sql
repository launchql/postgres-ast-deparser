-- Revert: schemas/launchql_private/procedures/uuid_generate_v4/grants/public from pg

BEGIN;


REVOKE EXECUTE ON FUNCTION
    "launchql_rls_private".uuid_generate_v4
FROM public;
COMMIT;  

