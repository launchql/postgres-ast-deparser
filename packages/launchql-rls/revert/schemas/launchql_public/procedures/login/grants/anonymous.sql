-- Revert: schemas/launchql_public/procedures/login/grants/anonymous from pg

BEGIN;


REVOKE EXECUTE ON FUNCTION
    "launchql_rls_public".login
FROM anonymous;
COMMIT;  

