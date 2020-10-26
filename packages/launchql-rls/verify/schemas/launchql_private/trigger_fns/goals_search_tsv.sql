-- Verify: schemas/launchql_private/trigger_fns/goals_search_tsv on pg

BEGIN;
SELECT verify_function('launchql_rls_private.goals_search_tsv');
COMMIT;  

