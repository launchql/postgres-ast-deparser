-- Revert: schemas/launchql_public/procedures/get_current_role_ids/grants/authenticated from pg

BEGIN;


REVOKE EXECUTE ON FUNCTION
    "launchql_rls_public".get_current_role_ids
FROM authenticated;
COMMIT;  

