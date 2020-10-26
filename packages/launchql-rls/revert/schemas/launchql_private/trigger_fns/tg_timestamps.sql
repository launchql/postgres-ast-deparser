-- Revert: schemas/launchql_private/trigger_fns/tg_timestamps from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".tg_timestamps();
COMMIT;  

