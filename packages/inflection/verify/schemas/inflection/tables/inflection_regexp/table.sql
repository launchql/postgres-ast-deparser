-- Verify schemas/inflection/tables/inflection_regexp/table on pg

BEGIN;

SELECT verify_table ('inflection.inflection_regexp');

ROLLBACK;
