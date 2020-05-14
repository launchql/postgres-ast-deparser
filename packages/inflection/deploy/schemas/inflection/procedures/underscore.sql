-- Deploy schemas/inflection/procedures/underscore to pg
-- requires: schemas/inflection/schema
-- requires: schemas/inflection/procedures/pg_slugify

BEGIN;
CREATE FUNCTION inflection.underscore (str text)
  RETURNS text
  AS $$
  WITH slugged AS (
    SELECT
      inflection.pg_slugify(str) AS value
),
convertedupper AS (
  SELECT
    lower(regexp_replace(value, E'([A-Z])', E'\_\\1', 'g')) AS value
  FROM
    slugged
),
noprefix AS (
  SELECT
    regexp_replace(value, E'^_', '', 'g') AS value
  FROM
    convertedupper
),
removedups AS (
  SELECT
    regexp_replace(value, E'[_]+', '_', 'gi') AS value
FROM
  noprefix
),
stripedges AS (
  SELECT
    regexp_replace(regexp_replace(value, E'([A-Z])_$', E'\\1', 'gi'), E'^_([A-Z])', E'\\1', 'gi') AS value
FROM
  removedups
)
SELECT
  value
FROM
  stripedges;
$$
LANGUAGE 'sql'
IMMUTABLE;
COMMIT;

