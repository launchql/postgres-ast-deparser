-- Revert: schemas/launchql_private/trigger_fns/goals_search_tsv from pg

BEGIN;
DROP FUNCTION "launchql_rls_private".goals_search_tsv;
COMMIT;  

