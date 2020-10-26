-- Revert: schemas/launchql_private/trigger_fns/immutable_field_tg from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".immutable_field_tg;
COMMIT;  

