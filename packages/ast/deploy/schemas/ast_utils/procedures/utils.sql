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

CREATE FUNCTION ast_utils.constrainttype_idxs (typ text)
returns int as $$
  select (CASE
WHEN (typ = 'CONSTR_NULL') THEN 0
WHEN (typ = 'CONSTR_NOTNULL') THEN 1
WHEN (typ = 'CONSTR_DEFAULT') THEN 2
WHEN (typ = 'CONSTR_IDENTITY') THEN 3
WHEN (typ = 'CONSTR_CHECK') THEN 4
WHEN (typ = 'CONSTR_PRIMARY') THEN 5
WHEN (typ = 'CONSTR_UNIQUE') THEN 6
WHEN (typ = 'CONSTR_EXCLUSION') THEN 7
WHEN (typ = 'CONSTR_FOREIGN') THEN 8
WHEN (typ = 'CONSTR_ATTR_DEFERRABLE') THEN 9
WHEN (typ = 'CONSTR_ATTR_NOT_DEFERRABLE') THEN 10
WHEN (typ = 'CONSTR_ATTR_DEFERRED') THEN 11
WHEN (typ = 'CONSTR_ATTR_IMMEDIATE') THEN 12
END);
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

CREATE FUNCTION ast_utils.objtypes_idxs (typ text)
returns int as $$
	select (CASE
WHEN (typ = 'OBJECT_ACCESS_METHOD') THEN 0
WHEN (typ = 'OBJECT_AGGREGATE') THEN 1
WHEN (typ = 'OBJECT_AMOP') THEN 2
WHEN (typ = 'OBJECT_AMPROC') THEN 3
WHEN (typ = 'OBJECT_ATTRIBUTE') THEN 4
WHEN (typ = 'OBJECT_CAST') THEN 5
WHEN (typ = 'OBJECT_COLUMN') THEN 6
WHEN (typ = 'OBJECT_COLLATION') THEN 7
WHEN (typ = 'OBJECT_CONVERSION') THEN 8
WHEN (typ = 'OBJECT_DATABASE') THEN 9
WHEN (typ = 'OBJECT_DEFAULT') THEN 10
WHEN (typ = 'OBJECT_DEFACL') THEN 11
WHEN (typ = 'OBJECT_DOMAIN') THEN 12
WHEN (typ = 'OBJECT_DOMCONSTRAINT') THEN 13
WHEN (typ = 'OBJECT_EVENT_TRIGGER') THEN 14
WHEN (typ = 'OBJECT_EXTENSION') THEN 15
WHEN (typ = 'OBJECT_FDW') THEN 16
WHEN (typ = 'OBJECT_FOREIGN_SERVER') THEN 17
WHEN (typ = 'OBJECT_FOREIGN_TABLE') THEN 18
WHEN (typ = 'OBJECT_FUNCTION') THEN 19
WHEN (typ = 'OBJECT_INDEX') THEN 20
WHEN (typ = 'OBJECT_LANGUAGE') THEN 21
WHEN (typ = 'OBJECT_LARGEOBJECT') THEN 22
WHEN (typ = 'OBJECT_MATVIEW') THEN 23
WHEN (typ = 'OBJECT_OPCLASS') THEN 24
WHEN (typ = 'OBJECT_OPERATOR') THEN 25
WHEN (typ = 'OBJECT_OPFAMILY') THEN 26
WHEN (typ = 'OBJECT_POLICY') THEN 27
WHEN (typ = 'OBJECT_PUBLICATION') THEN 28
WHEN (typ = 'OBJECT_PUBLICATION_REL') THEN 29
WHEN (typ = 'OBJECT_ROLE') THEN 30
WHEN (typ = 'OBJECT_RULE') THEN 31
WHEN (typ = 'OBJECT_SCHEMA') THEN 32
WHEN (typ = 'OBJECT_SEQUENCE') THEN 33
WHEN (typ = 'OBJECT_SUBSCRIPTION') THEN 34
WHEN (typ = 'OBJECT_STATISTIC_EXT') THEN 35
WHEN (typ = 'OBJECT_TABCONSTRAINT') THEN 36
WHEN (typ = 'OBJECT_TABLE') THEN 37
WHEN (typ = 'OBJECT_TABLESPACE') THEN 38
WHEN (typ = 'OBJECT_TRANSFORM') THEN 39
WHEN (typ = 'OBJECT_TRIGGER') THEN 40
WHEN (typ = 'OBJECT_TSCONFIGURATION') THEN 41
WHEN (typ = 'OBJECT_TSDICTIONARY') THEN 42
WHEN (typ = 'OBJECT_TSPARSER') THEN 43
WHEN (typ = 'OBJECT_TSTEMPLATE') THEN 44
WHEN (typ = 'OBJECT_TYPE') THEN 45
WHEN (typ = 'OBJECT_USER_MAPPING') THEN 46
WHEN (typ = 'OBJECT_VIEW') THEN 47
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
