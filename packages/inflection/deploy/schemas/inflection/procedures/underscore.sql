-- Deploy schemas/inflection/procedures/underscore to pg

-- requires: schemas/inflection/schema
-- requires: schemas/inflection/procedures/slugify

-- TODO not sure if we should slugify here

BEGIN;

CREATE FUNCTION inflection.underscore(
  str text
) returns text as $$
  SELECT lower(regexp_replace(inflection.slugify(str), E'([A-Z])', E'\_\\1','g'));
$$
LANGUAGE 'sql' IMMUTABLE;

COMMIT;
