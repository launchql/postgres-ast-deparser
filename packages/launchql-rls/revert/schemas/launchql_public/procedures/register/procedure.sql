-- Revert: schemas/launchql_public/procedures/register/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_public".register;

COMMIT;  

