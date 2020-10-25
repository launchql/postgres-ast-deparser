-- Deploy schemas/ast_utils/procedures/utils to pg

-- requires: schemas/ast_utils/schema

BEGIN;

CREATE FUNCTION ast_utils.interval (
  n int
) returns text[] as $$
	select (CASE 
WHEN ( n = 2 ) THEN ARRAY[ 'month' ]
WHEN ( n = 4 ) THEN ARRAY[ 'year' ]
WHEN ( n = 6 ) THEN ARRAY[ 'year', 'month' ]
WHEN ( n = 8 ) THEN ARRAY[ 'day' ]
WHEN ( n = 1024 ) THEN ARRAY[ 'hour' ]
WHEN ( n = 1032 ) THEN ARRAY[ 'day', 'hour' ]
WHEN ( n = 2048 ) THEN ARRAY[ 'minute' ]
WHEN ( n = 3072 ) THEN ARRAY[ 'hour', 'minute' ]
WHEN ( n = 3080 ) THEN ARRAY[ 'day', 'minute' ]
WHEN ( n = 4096 ) THEN ARRAY[ 'second' ]
WHEN ( n = 6144 ) THEN ARRAY[ 'minute', 'second' ]
WHEN ( n = 7168 ) THEN ARRAY[ 'hour', 'second' ]
WHEN ( n = 7176 ) THEN ARRAY[ 'day', 'second' ]
WHEN ( n = 32767 ) THEN ARRAY[]::text[]
END);
$$  
LANGUAGE 'sql' IMMUTABLE;

CREATE FUNCTION ast_utils.reserved (
  str text
) returns boolean as $$
	select exists( select 1 from pg_get_keywords() where catcode = 'R' AND word=str  );
$$  
LANGUAGE 'sql' SECURITY DEFINER;

CREATE FUNCTION ast_utils.objtypes ()
returns text[] as $$
	select ARRAY[ 'ACCESS METHOD', 'AGGREGATE', NULL, NULL, NULL, 'CAST', 'COLUMN', 'COLLATION', 'CONVERSION', 'DATABASE', NULL, NULL, 'DOMAIN', 'CONSTRAINT', NULL, 'EXTENSION', 'FOREIGN DATA WRAPPER', 'SERVER', 'FOREIGN TABLE', 'FUNCTION', 'INDEX', 'LANGUAGE', 'LARGE OBJECT', 'MATERIALIZED VIEW', 'OPERATOR CLASS', 'OPERATOR', 'OPERATOR FAMILY', 'POLICY', NULL, NULL, 'ROLE', 'RULE', 'SCHEMA', 'SEQUENCE', NULL, 'STATISTICS', 'CONSTRAINT', 'TABLE', 'TABLESPACE', 'TRANSFORM', 'TRIGGER', 'TEXT SEARCH CONFIGURATION', 'TEXT SEARCH DICTIONARY', 'TEXT SEARCH PARSER', 'TEXT SEARCH TEMPLATE', 'TYPE', NULL, 'VIEW' ]::text[];
$$  
LANGUAGE 'sql' IMMUTABLE;

CREATE FUNCTION ast_utils.objtype_name(typenum int)
returns text as $$
	select (ast_utils.objtypes())[typenum + 1];
$$  
LANGUAGE 'sql' IMMUTABLE;

CREATE FUNCTION ast_utils.constrainttypes (contype int)
returns text as $$
  select (CASE
WHEN (contype =  0 ) THEN 'NULL'
WHEN (contype =  1 ) THEN 'NOT NULL'
WHEN (contype =  2 ) THEN 'DEFAULT'
WHEN (contype =  4 ) THEN 'CHECK'
WHEN (contype =  5 ) THEN 'PRIMARY KEY'
WHEN (contype =  6 ) THEN 'UNIQUE'
WHEN (contype =  7 ) THEN 'EXCLUDE'
WHEN (contype =  8 ) THEN 'REFERENCES'
END);
$$
LANGUAGE 'sql' IMMUTABLE;

CREATE FUNCTION ast_utils.getgrantobject (node jsonb)
returns text as $$
DECLARE
  objtype int;
  targtype int;
BEGIN 

  objtype = (node->'objtype')::int;
  IF (node->'targtype') IS NOT NULL THEN
    targtype = (node->'targtype')::int;
  END IF;

  IF (objtype = 0) THEN
    RETURN 'COLUMN';
  ELSIF (objtype = 1) THEN
    IF (targtype = 1) THEN 
      RETURN 'ALL TABLES IN SCHEMA';
    ELSIF (targtype = 2) THEN 
      RETURN 'TABLES';
    END IF;
    -- TODO could be a view
    RETURN 'TABLE';
  ELSIF (objtype = 2) THEN
    RETURN 'SEQUENCE';
  ELSIF (objtype = 3) THEN
    RETURN 'DATABASE';
  ELSIF (objtype = 4) THEN
    RETURN 'DOMAIN';
  ELSIF (objtype = 5) THEN
    RETURN 'FOREIGN DATA WRAPPER';
  ELSIF (objtype = 6) THEN
    RETURN 'FOREIGN SERVER';
  ELSIF (objtype = 7) THEN
    IF (targtype = 1) THEN 
      RETURN 'ALL FUNCTIONS IN SCHEMA';
    ELSIF (targtype = 2) THEN 
      RETURN 'FUNCTIONS';
    END IF;
    RETURN 'FUNCTION';
  ELSIF (objtype = 8) THEN
    RETURN 'LANGUAGE';
  ELSIF (objtype = 9) THEN
    RETURN 'LARGE OBJECT';
  ELSIF (objtype = 10) THEN
    RETURN 'SCHEMA';
  ELSIF (objtype = 11) THEN
    RETURN 'TABLESPACE';
  ELSIF (objtype = 12) THEN
    RETURN 'TYPE';
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantObjectType';

END;
$$  
LANGUAGE 'plpgsql' IMMUTABLE;

COMMIT;
