-- Revert: schemas/launchql_public/procedures/get_current_user_id/grants/authenticated from pg

BEGIN;


REVOKE EXECUTE ON FUNCTION
    "launchql_rls_public".get_current_user_id
FROM authenticated;
COMMIT;  

