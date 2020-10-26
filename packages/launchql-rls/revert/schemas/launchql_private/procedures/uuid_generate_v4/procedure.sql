-- Revert: schemas/launchql_private/procedures/uuid_generate_v4/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".uuid_generate_v4;
COMMIT;  

