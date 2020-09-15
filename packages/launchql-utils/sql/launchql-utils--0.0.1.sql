\echo Use "CREATE EXTENSION launchql-utils" to load this file. \quit
CREATE FUNCTION make_tsrange ( start_at timestamptz, end_at timestamptz, type text DEFAULT '[]' ) RETURNS tsrange AS $EOFCODE$
    SELECT (substr(type, 1,1) || start_at || ',' || end_at || substr(type, 2,1))::tsrange;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

GRANT EXECUTE ON FUNCTION make_tsrange TO PUBLIC;

GRANT EXECUTE ON FUNCTION crypt TO PUBLIC;

GRANT EXECUTE ON FUNCTION gen_salt ( text ) TO PUBLIC;