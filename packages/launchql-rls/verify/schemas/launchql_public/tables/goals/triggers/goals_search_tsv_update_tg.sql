-- Verify: schemas/launchql_public/tables/goals/triggers/goals_search_tsv_update_tg on pg

BEGIN;
SELECT verify_trigger('launchql_rls_public.goals_search_tsv_update_tg');
COMMIT;  

