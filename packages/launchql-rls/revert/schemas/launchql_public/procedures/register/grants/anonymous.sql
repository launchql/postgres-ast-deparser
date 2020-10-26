-- Revert: schemas/launchql_public/procedures/register/grants/anonymous from pg

BEGIN;


REVOKE EXECUTE ON FUNCTION
    "launchql_rls_public".register
FROM anonymous;
COMMIT;  

