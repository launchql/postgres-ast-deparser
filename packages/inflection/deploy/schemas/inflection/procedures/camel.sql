-- Deploy schemas/inflection/procedures/camel to pg

-- requires: schemas/inflection/schema
-- requires: schemas/inflection/procedures/pascal

BEGIN;

CREATE FUNCTION inflection.camel (str text)
  RETURNS text
  AS $$
  SELECT
    lower(substring(inflection.pascal (str), 1, 1)) || substring(inflection.pascal (str), 2);
$$
LANGUAGE sql
IMMUTABLE;

COMMIT;
