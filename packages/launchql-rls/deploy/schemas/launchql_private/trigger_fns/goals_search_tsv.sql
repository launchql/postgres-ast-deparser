-- Deploy: schemas/launchql_private/trigger_fns/goals_search_tsv to pg
-- made with <3 @ launchql.com

-- requires: schemas/launchql_private/schema
-- requires: schemas/launchql_public/tables/goals/triggers/tg_timestamps

BEGIN;
CREATE FUNCTION "launchql_private".goals_search_tsv ( ) RETURNS TRIGGER AS $LQLCODEZ$ 
 
BEGIN
NEW.search = setweight(to_tsvector('pg_catalog.english', COALESCE(array_to_string(NEW.tags::citext[], ' '), '')), 'C') || setweight(to_tsvector('pg_catalog.english', COALESCE(NEW.sub_head, '')), 'B') || setweight(to_tsvector('pg_catalog.simple', COALESCE(NEW.name, '')), 'A');
RETURN NEW;
END; 
 $LQLCODEZ$ LANGUAGE plpgsql VOLATILE;
COMMIT;
