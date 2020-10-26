-- Deploy: schemas/launchql_public/tables/goals/triggers/goals_search_tsv_insert_tg to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_public/schema
-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_public/tables/goals/table
-- requires: schemas/launchql_private/trigger_fns/goals_search_tsv

BEGIN;
CREATE TRIGGER goals_search_tsv_insert_tg 
 BEFORE INSERT ON "launchql_public".goals 
 FOR EACH ROW 
 EXECUTE PROCEDURE "launchql_private".goals_search_tsv ( );
COMMIT;
