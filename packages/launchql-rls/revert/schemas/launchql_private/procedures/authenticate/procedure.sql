-- Revert: schemas/launchql_private/procedures/authenticate/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".authenticate;
COMMIT;  

