-- Revert: schemas/launchql_private/procedures/seeded_uuid_related_trigger/grants/public from pg

BEGIN;


REVOKE EXECUTE ON FUNCTION
    "launchql_rls_private".seeded_uuid_related_trigger
FROM public;
COMMIT;  

