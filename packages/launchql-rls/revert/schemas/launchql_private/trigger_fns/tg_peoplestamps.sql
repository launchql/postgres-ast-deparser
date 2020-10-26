-- Revert: schemas/launchql_private/trigger_fns/tg_peoplestamps from pg

BEGIN;


DROP FUNCTION "launchql_rls_private".tg_peoplestamps();
COMMIT;  

