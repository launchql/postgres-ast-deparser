-- Revert: schemas/launchql_private/procedures/seeded_uuid_related_trigger/procedure from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".seeded_uuid_related_trigger;
COMMIT;  

