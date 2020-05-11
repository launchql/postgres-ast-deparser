-- Deploy schemas/inflection/procedures/pascal to pg

-- requires: schemas/inflection/schema

BEGIN;

-- http://www.postgresonline.com/journal/archives/170-Of-Camels-and-People-Converting-back-and-forth-from-Camel-Case,-Pascal-Case-to--underscore-lower-case.html

BEGIN;

CREATE FUNCTION inflection.pascal(
  str text
) returns text as $$
  SELECT replace(initcap(replace(str, '_', ' ')), ' ', '');
$$
LANGUAGE 'sql' IMMUTABLE;

COMMIT;
