-- Revert: schemas/launchql_public/procedures/login/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_public".login;
COMMIT;  

