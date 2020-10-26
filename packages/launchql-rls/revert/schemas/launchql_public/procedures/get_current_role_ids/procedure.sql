-- Revert: schemas/launchql_public/procedures/get_current_role_ids/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_public".get_current_role_ids;

COMMIT;  

