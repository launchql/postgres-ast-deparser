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

CREATE FUNCTION ast_utils.objtype_name (objtype text)
returns text as $$
  select (CASE objtype
WHEN 'OBJECT_ACCESS_METHOD' THEN 'ACCESS METHOD'
WHEN 'OBJECT_AGGREGATE' THEN 'AGGREGATE'
WHEN 'OBJECT_AMOP' THEN NULL -- TODO  
WHEN 'OBJECT_AMPROC' THEN NULL -- TODO 
WHEN 'OBJECT_ATTRIBUTE' THEN 'ATTRIBUTE'
WHEN 'OBJECT_CAST' THEN 'CAST'
WHEN 'OBJECT_COLUMN' THEN 'COLUMN'
WHEN 'OBJECT_COLLATION' THEN 'COLLATION'
WHEN 'OBJECT_CONVERSION' THEN 'CONVERSION'
WHEN 'OBJECT_DATABASE' THEN 'DATABASE'
WHEN 'OBJECT_DEFAULT' THEN NULL -- TODO 
WHEN 'OBJECT_DEFACL' THEN NULL -- TODO 
WHEN 'OBJECT_DOMAIN' THEN 'DOMAIN'
WHEN 'OBJECT_DOMCONSTRAINT' THEN 'CONSTRAINT'
WHEN 'OBJECT_EVENT_TRIGGER' THEN 'EVENT TRIGGER'
WHEN 'OBJECT_EXTENSION' THEN 'EXTENSION'
WHEN 'OBJECT_FDW' THEN 'FOREIGN DATA WRAPPER'
WHEN 'OBJECT_FOREIGN_SERVER' THEN 'SERVER'
WHEN 'OBJECT_FOREIGN_TABLE' THEN 'FOREIGN TABLE'
WHEN 'OBJECT_FUNCTION' THEN 'FUNCTION'
WHEN 'OBJECT_INDEX' THEN 'INDEX'
WHEN 'OBJECT_LANGUAGE' THEN 'LANGUAGE'
WHEN 'OBJECT_LARGEOBJECT' THEN 'LARGE OBJECT'
WHEN 'OBJECT_MATVIEW' THEN 'MATERIALIZED VIEW'
WHEN 'OBJECT_OPCLASS' THEN 'OPERATOR CLASS'
WHEN 'OBJECT_OPERATOR' THEN 'OPERATOR'
WHEN 'OBJECT_OPFAMILY' THEN 'OPERATOR FAMILY'
WHEN 'OBJECT_POLICY' THEN 'POLICY'
WHEN 'OBJECT_PROCEDURE' THEN 'PROCEDURE'
WHEN 'OBJECT_PUBLICATION' THEN 'PUBLICATION'
WHEN 'OBJECT_PUBLICATION_REL' THEN NULL -- TODO 
WHEN 'OBJECT_ROLE' THEN 'ROLE'
WHEN 'OBJECT_ROUTINE' THEN 'ROUTINE'
WHEN 'OBJECT_RULE' THEN 'RULE'
WHEN 'OBJECT_SCHEMA' THEN 'SCHEMA'
WHEN 'OBJECT_SEQUENCE' THEN 'SEQUENCE'
WHEN 'OBJECT_SUBSCRIPTION' THEN 'SUBSCRIPTION'
WHEN 'OBJECT_STATISTIC_EXT' THEN 'STATISTICS'
WHEN 'OBJECT_TABCONSTRAINT' THEN 'CONSTRAINT'
WHEN 'OBJECT_TABLE' THEN 'TABLE'
WHEN 'OBJECT_TABLESPACE' THEN 'TABLESPACE'
WHEN 'OBJECT_TRANSFORM' THEN 'TRANSFORM'
WHEN 'OBJECT_TRIGGER' THEN 'TRIGGER'
WHEN 'OBJECT_TSCONFIGURATION' THEN 'TEXT SEARCH CONFIGURATION'
WHEN 'OBJECT_TSDICTIONARY' THEN 'TEXT SEARCH DICTIONARY'
WHEN 'OBJECT_TSPARSER' THEN 'TEXT SEARCH PARSER'
WHEN 'OBJECT_TSTEMPLATE' THEN 'TEXT SEARCH TEMPLATE'
WHEN 'OBJECT_TYPE' THEN 'TYPE'
WHEN 'OBJECT_USER_MAPPING' THEN 'USER MAPPING'
WHEN 'OBJECT_VIEW' THEN 'VIEW'
END);
$$
LANGUAGE 'sql' IMMUTABLE;

CREATE FUNCTION ast_utils.constrainttypes (contype text)
returns text as $$
  select (CASE contype
WHEN 'CONSTR_NULL' THEN 'NULL'
WHEN 'CONSTR_NOTNULL' THEN 'NOT NULL'
WHEN 'CONSTR_DEFAULT' THEN 'DEFAULT'
WHEN 'CONSTR_CHECK' THEN 'CHECK'
WHEN 'CONSTR_PRIMARY' THEN 'PRIMARY KEY'
WHEN 'CONSTR_UNIQUE' THEN 'UNIQUE'
WHEN 'CONSTR_EXCLUSION' THEN 'EXCLUDE'
WHEN 'CONSTR_FOREIGN' THEN 'REFERENCES'
END);
$$
LANGUAGE 'sql' IMMUTABLE;

CREATE FUNCTION ast_utils.getgrantobject (node jsonb)
returns text as $$
DECLARE
  objtype text;
  targtype text;
BEGIN 

  objtype = node->>'objtype';
  IF (node->'targtype') IS NOT NULL THEN
    targtype = node->>'targtype';
  END IF;

  IF (objtype = 'OBJECT_COLUMN') THEN
    RETURN 'COLUMN';
  ELSIF (objtype = 'OBJECT_TABLE') THEN
    IF (targtype = 'ACL_TARGET_ALL_IN_SCHEMA') THEN 
      RETURN 'ALL TABLES IN SCHEMA';
    ELSIF (targtype = 'ACL_TARGET_DEFAULTS') THEN 
      RETURN 'TABLES';
    END IF;
    -- TODO could be a view
    RETURN 'TABLE';
  ELSIF (objtype = 'OBJECT_SEQUENCE') THEN
    RETURN 'SEQUENCE';
  ELSIF (objtype = 'OBJECT_DATABASE') THEN
    RETURN 'DATABASE';
  ELSIF (objtype = 'OBJECT_DOMAIN') THEN
    RETURN 'DOMAIN';
  ELSIF (objtype = 'OBJECT_FDW') THEN
    RETURN 'FOREIGN DATA WRAPPER';
  ELSIF (objtype = 'OBJECT_FOREIGN_SERVER') THEN
    RETURN 'FOREIGN SERVER';
  ELSIF (objtype = 'OBJECT_FUNCTION') THEN
    IF (targtype = 'ACL_TARGET_ALL_IN_SCHEMA') THEN 
      RETURN 'ALL FUNCTIONS IN SCHEMA';
    ELSIF (targtype = 'ACL_TARGET_DEFAULTS') THEN 
      RETURN 'FUNCTIONS';
    END IF;
    RETURN 'FUNCTION';
  ELSIF (objtype = 'OBJECT_LANGUAGE') THEN
    RETURN 'LANGUAGE';
  ELSIF (objtype = 'OBJECT_LARGEOBJECT') THEN
    RETURN 'LARGE OBJECT';
  ELSIF (objtype = 'OBJECT_SCHEMA') THEN
    RETURN 'SCHEMA';
  ELSIF (objtype = 'OBJECT_TABLESPACE') THEN
    RETURN 'TABLESPACE';
  ELSIF (objtype = 'OBJECT_TYPE') THEN
    RETURN 'TYPE';
  END IF;

  RAISE EXCEPTION 'BAD_EXPRESSION %', 'GrantObjectType';

END;
$$  
LANGUAGE 'plpgsql' IMMUTABLE;

COMMIT;
