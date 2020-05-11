\echo Use "CREATE EXTENSION inflection" to load this file. \quit
CREATE SCHEMA inflection;

CREATE FUNCTION inflection.pascal ( str text ) RETURNS text AS $EOFCODE$
  SELECT replace(initcap(replace(str, '_', ' ')), ' ', '');
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION inflection.camel ( str text ) RETURNS text AS $EOFCODE$
  SELECT
    lower(substring(inflection.pascal (str), 1, 1)) || substring(inflection.pascal (str), 2);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION inflection.slugify ( value text, allow_unicode boolean ) RETURNS text AS $EOFCODE$
  WITH normalized AS (
    SELECT
      CASE WHEN allow_unicode THEN
        value
      ELSE
        unaccent (value)
      END AS value
),
remove_chars AS (
  SELECT
    regexp_replace(value, E'[^\\w\\s-]', '', 'gi') AS value
FROM
  normalized
),
lowercase AS (
  SELECT
    lower(value) AS value
FROM
  remove_chars
),
trimmed AS (
  SELECT
    trim(value) AS value
FROM
  lowercase
),
hyphenated AS (
  SELECT
    regexp_replace(value, E'[-\\s]+', '-', 'gi') AS value
FROM
  trimmed
)
SELECT
  value
FROM
  hyphenated;
$EOFCODE$ LANGUAGE sql STRICT IMMUTABLE;

CREATE FUNCTION inflection.slugify (  text ) RETURNS text AS $EOFCODE$SELECT inflection.slugify($1, false)$EOFCODE$ LANGUAGE sql IMMUTABLE STRICT;

CREATE FUNCTION inflection.underscore ( str text ) RETURNS text AS $EOFCODE$
  SELECT lower(regexp_replace(inflection.slugify(str), E'([A-Z])', E'\_\\1','g'));
$EOFCODE$ LANGUAGE sql IMMUTABLE;