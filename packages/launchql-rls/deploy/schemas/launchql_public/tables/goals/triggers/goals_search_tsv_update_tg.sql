-- Deploy: schemas/launchql_public/tables/goals/triggers/goals_search_tsv_update_tg to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_private/trigger_fns/goals_search_tsv
-- requires: schemas/launchql_public/tables/goals/triggers/goals_search_tsv_insert_tg

BEGIN;
CREATE TRIGGER goals_search_tsv_update_tg 
 BEFORE UPDATE ON "launchql_public".goals 
 FOR EACH ROW 
 WHEN (OLD.name IS DISTINCT FROM NEW.name OR OLD.sub_head IS DISTINCT FROM NEW.sub_head OR OLD.tags IS DISTINCT FROM NEW.tags) 
 EXECUTE PROCEDURE "launchql_private".goals_search_tsv ( );
COMMIT;
