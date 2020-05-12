\echo Use "CREATE EXTENSION inflection" to load this file. \quit
CREATE SCHEMA inflection;

CREATE FUNCTION inflection.no_consecutive_caps ( str text ) RETURNS text AS $EOFCODE$
DECLARE
  result text[];
  temp text;
BEGIN
    FOR result IN
    SELECT regexp_matches(str, E'([A-Z])([A-Z]+)', 'g')
      LOOP
        temp = result[1] || lower(result[2]);
        str = replace(str, result[1] || result[2], temp);
      END LOOP;

  return str;
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION inflection.pg_slugify ( value text, allow_unicode boolean ) RETURNS text AS $EOFCODE$
  WITH normalized AS (
    SELECT
      CASE WHEN allow_unicode THEN
        value
      ELSE
        unaccent (value)
      END AS value
),
no_consecutive_caps AS (
  SELECT
    inflection.no_consecutive_caps (value) AS value
FROM
  normalized
),
remove_chars AS (
  SELECT
    regexp_replace(value, E'[^\\w\\s-]', '', 'gi') AS value
FROM
  no_consecutive_caps
),
trimmed AS (
  SELECT
    trim(value) AS value
FROM
  remove_chars
),
hyphenated AS (
  SELECT
    regexp_replace(value, E'[-\\s]+', '-', 'gi') AS value
FROM
  trimmed
),
underscored AS (
  SELECT
    regexp_replace(value, E'[-]+', '_', 'gi') AS value
FROM
  hyphenated
),
removedups AS (
  SELECT
    regexp_replace(value, E'[_]+', '_', 'gi') AS value
FROM
  underscored
)
SELECT
  value
FROM
  removedups;
$EOFCODE$ LANGUAGE sql STRICT IMMUTABLE;

CREATE FUNCTION inflection.pg_slugify (  text ) RETURNS text AS $EOFCODE$SELECT inflection.pg_slugify($1, false)$EOFCODE$ LANGUAGE sql IMMUTABLE STRICT;

CREATE FUNCTION inflection.underscore ( str text ) RETURNS text AS $EOFCODE$
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
)
SELECT
  value
FROM
  removedups;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION inflection.camel ( str text ) RETURNS text AS $EOFCODE$
DECLARE
  result text[];
BEGIN
    str = inflection.underscore(str);
    FOR result IN
    SELECT regexp_matches(str,  E'(_[a-zA-Z0-9])', 'g')
      LOOP
        str = replace(str, result[1], upper(result[1]));
      END LOOP;
  return regexp_replace(substring(str FROM 1 FOR 1) || substring(str FROM 2 FOR length(str)), E'[_]+', '', 'gi');
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

CREATE FUNCTION inflection.pascal ( str text ) RETURNS text AS $EOFCODE$
DECLARE
  result text[];
BEGIN
    str = inflection.camel(str);
  return upper(substring(str FROM 1 FOR 1)) || substring(str FROM 2 FOR length(str));
END;
$EOFCODE$ LANGUAGE plpgsql STABLE;

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