-- Revert: schemas/launchql_private/procedures/uuid_generate_seeded_uuid/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".uuid_generate_seeded_uuid;
COMMIT;  

