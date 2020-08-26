\echo Use "CREATE EXTENSION skitch-extension-utils" to load this file. \quit
CREATE FUNCTION get_entity_from_str ( qualified_name text ) RETURNS text AS $EOFCODE$
DECLARE
    parts text[];
    BEGIN
    SELECT
        * INTO parts
    FROM
        regexp_split_to_array(qualified_name, E'\\.');

    IF cardinality(parts) > 1 THEN
        RETURN parts[2];
    ELSE
        RETURN parts[1];
        END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STRICT;

CREATE FUNCTION get_schema_from_str ( qualified_name text ) RETURNS text AS $EOFCODE$
DECLARE
    parts text[];
    BEGIN
    SELECT
        * INTO parts
    FROM
        regexp_split_to_array(qualified_name, E'\\.');

    IF cardinality(parts) > 1 THEN
        RETURN parts[1];
    ELSE
        RETURN 'public';
        END IF;
END;
$EOFCODE$ LANGUAGE plpgsql STRICT;

CREATE FUNCTION list_indexes ( _table text, _index text ) RETURNS TABLE ( schema_name text, table_name text, index_name text ) AS $EOFCODE$
SELECT
    n.nspname::text AS schema_name,
    t.relname::text AS table_name,
    i.relname::text AS index_name
FROM
    pg_class t,
    pg_class i,
    pg_index ix,
    pg_catalog.pg_namespace n
WHERE
    t.oid = ix.indrelid
    AND i.oid = ix.indexrelid
    AND n.oid = i.relnamespace
    AND n.nspname = get_schema_from_str(_table)
    AND i.relname = _index
    AND t.relname = get_entity_from_str(_table);
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION list_memberships ( _user text ) RETURNS TABLE ( rolname text ) AS $EOFCODE$ WITH RECURSIVE cte AS (
    SELECT
        oid
    FROM
        pg_roles
    WHERE
        rolname = _user
    UNION ALL
    SELECT
        m.roleid
    FROM
        cte
        JOIN pg_auth_members m ON m.member = cte.oid
)
SELECT
    pg_roles.rolname::text AS rolname
FROM
    cte c,
    pg_roles
WHERE
    pg_roles.oid = c.oid;
$EOFCODE$ LANGUAGE sql IMMUTABLE;

CREATE FUNCTION tg_update_timestamps (  ) RETURNS trigger AS $EOFCODE$
BEGIN
    IF TG_OP = 'INSERT' THEN
      NEW.created_at = NOW();
      NEW.updated_at = NOW();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.created_at = OLD.created_at;
      NEW.updated_at = NOW();
    END IF;
    RETURN NEW;
END;
$EOFCODE$ LANGUAGE plpgsql;