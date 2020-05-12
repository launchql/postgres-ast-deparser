-- Revert schemas/inflection/tables/inflection_regexp/table from pg

BEGIN;

DROP TABLE inflection.inflection_regexp;

COMMIT;
