-- Deploy procedures/make_tsrange to pg

BEGIN;

CREATE FUNCTION make_tsrange(
  start_at TIMESTAMPTZ,
  end_at TIMESTAMPTZ,
  type text DEFAULT '[]'
)
  RETURNS tsrange
AS $$
    SELECT (substr(type, 1,1) || start_at || ',' || end_at || substr(type, 2,1))::tsrange;
$$
LANGUAGE 'sql'
IMMUTABLE;

GRANT EXECUTE ON FUNCTION make_tsrange TO PUBLIC;

COMMIT;
