-- Revert: schemas/launchql_public/tables/goals/triggers/goals_search_tsv_update_tg from pg

BEGIN;
DROP TRIGGER goals_search_tsv_update_tg ON "launchql_rls_public".goals;
COMMIT;  

