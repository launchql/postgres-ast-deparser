# Postgres AST Deparser for Postgres

A pure plpgsql AST toolkit and deparser for PostgreSQL. This is the plpgsql equivalent of https://github.com/pyramation/pgsql-parser for deparsing, which can be used to create ASTs and deparse them back into strings in native Postgres.

## Why?

For dynamic SQL, string concatenation can be problematic, and AST trees are the DNA of software itself — why not use them instead?

### a note on compatibility

Written entirely in plpgsql and can be installed anywhere, even in managed RDBMS environments that don't support untrusted extensions.

## Areas of interest

### schemas 

 - `deparser` contains the deparser [(the `deparse()` function)](packages/ast/deploy/schemas/deparser/procedures/deparse.sql) — where the magic happens ✨ 
 - `ast` contains [tools for building AST trees](packages/ast/deploy/schemas/ast/procedures/types.sql)
 - `ast_helpers` contains [Helpers for higher level AST trees, like `create_table`](packages/ast/deploy/schemas/ast_helpers/procedures/helpers.sql)

### extension

While the project uses [sqitch](https://sqitch.org/), we've bundled it into a single file and extension using [launchql/cli](https://github.com/launchql/launchql)

 - the extension lives in [packages/ast/sql](packages/ast/sql)
## Usage

Use the `deparser.deparse()` function to deparse Postgres AST trees, in SQL:

```sql
select deparser.deparse( $1::jsonb );
```
## Examples

You can pretty much write any SQL statement you can think of. Here are only a few examples. Read the [the tests](packages/ast/test) for more.
#### select

```sql
SELECT * FROM deparser.deparse(
  ast.select_stmt(
    v_op := 'SETOP_NONE',
    v_targetList := to_jsonb(ARRAY[
        ast.res_target(
            v_val := ast_helpers.col('mt', 'my_field')
        )
    ]),
    v_fromClause := to_jsonb(ARRAY[
        ast_helpers.range_var(
            v_schemaname := 'my_schema_name',
            v_relname := 'my_table_name',
            v_alias := ast.alias(
                v_aliasname := 'mt'
            )
        )
    ]),
    v_whereClause := ast_helpers.eq(
        v_lexpr := ast_helpers.col('mt', 'id'),
        v_rexpr := ast.a_const(
            v_val := ast.integer(2)
        )
    )
  )
);
```

produces

```sql
SELECT mt.my_field FROM my_schema_name.my_table_name AS mt WHERE mt.id = 2
```

#### create table

```sql
select deparser.deparse(
    ast_helpers.create_table(
		v_schema_name := 'my_schema_name',
		v_table_name := 'my_table_name'
	)
);
```

produces 

```sql
CREATE TABLE my_schema_name.my_table_name (
  
);
```

#### alter table add column

```sql
select
    deparser.expression(
        ast_helpers.alter_table_add_column(
            v_schema_name := 'myschema',
            v_table_name := 'mytable',
            v_column_name := 'mycolumn',
            v_column_type := 'Geometry(Polygon, 4326)' :: text
        )
    );
```

produces

```sql
ALTER TABLE
    myschema.mytable
ADD
    COLUMN mycolumn pg_catalog.Geometry(Polygon, 4326);
```

#### rename column

```sql
select deparser.expression(
	ast_helpers.alter_table_rename_column(
		v_schema_name := 'myschema',
		v_table_name := 'mytable',
		v_old_column_name := 'my-column1',
		v_new_column_name := 'mycolumn2'
	)
);
```

produces 

```sql
ALTER TABLE myschema.mytable RENAME COLUMN "my-column1" TO mycolumn2;
```

#### alter table set column data type

```sql
select deparser.expression(
    ast_helpers.alter_table_set_column_data_type(
        v_schema_name := 'myschema',
        v_table_name := 'mytable',
        v_column_name := 'mycolumn1',
        v_old_column_type := 'othertype',
        v_new_column_type := 'mycustomtype'
    )
);
```

produces

```sql
ALTER TABLE
    myschema.mytable
ALTER COLUMN
    mycolumn1 TYPE mycustomtype USING mycolumn1::mycustomtype;
```
#### create index

```sql
select deparser.deparse(
	ast_helpers.create_index(
		v_index_name := 'v_index_name',
		v_schema_name := 'v_schema_name',
		v_table_name := 'v_table_name',
		v_fields := '{a,b,c}',
		v_include_fields := '{a,b}',
		v_unique := TRUE,
		v_accessMethod := 'GIST'
	)
);
```

produces

```sql
CREATE UNIQUE INDEX v_index_name ON v_schema_name.v_table_name USING GIST (a, b, c) INCLUDE (a, b);
```

### add check constraint

```sql
select deparser.expression(
    ast_helpers.alter_table_add_check_constraint(
        v_schema_name := 'schema_name',
        v_table_name := 'table_name',
        v_constraint_name := 'constraint_name',
        v_constraint_expr := ast_helpers.matches(
            v_lexpr := ast.column_ref(
                v_fields := to_jsonb(ARRAY[
                    ast.string('email')
                ])
            ),
            v_regexp := '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
        )
    )
);
```

produces

```sql
ALTER TABLE schema_name.table_name ADD CONSTRAINT constraint_name CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
```

#### create function

Here is an example that uses `create_function`:

```sql
SELECT deparser.deparse(ast_helpers.create_function(
  v_schema_name := 'schema',
  v_function_name := 'name',
  v_type := 'TRIGGER',
  v_parameters := to_jsonb(ARRAY[
    ast_helpers.simple_param(
      'param1',
      'text'
    ),
    ast_helpers.simple_param(
      'active',
      'bool'
    ),
    ast_helpers.simple_param(
      'sid',
      'uuid',
      'uuid_generate_v4()'
    ),
    ast_helpers.simple_param(
      'description',
      'text',
      'NULL'
    ),
    ast_helpers.simple_param(
      'tags',
      'text[]',
      ast.a_const(ast.null())
    )
  ]::jsonb[]),
  v_body := 'code here',
  v_volatility := 'volatile',
  v_language := 'plpgsql',
  v_security := 0
));
```

produces

```sql
CREATE FUNCTION schema.name ( 
    param1 text,
    active bool,
    sid uuid DEFAULT uuid_generate_v4(),
    description text DEFAULT NULL,
    tags text[] DEFAULT NULL
) RETURNS TRIGGER AS $LQLCODEZ$ 
 code here 
$LQLCODEZ$ LANGUAGE plpgsql VOLATILE;
 ```

 #### drop function

```sql
SELECT deparser.deparse(ast_helpers.drop_function(
  v_schema_name := 'schema',
  v_function_name := 'name'
));
```
produces

```sql
DROP FUNCTION schema.name;
```

#### table grant

```sql
select deparser.expression(
    ast_helpers.table_grant(
        v_schema_name := 'myschema',
        v_table_name := 'mytable',
        v_priv_name := 'update',
        v_cols := ARRAY['col1', 'column-name-dashes'],
        v_is_grant := true,
        v_role_name := 'authenticated'
        )
    );
```

produces

```sql
GRANT UPDATE ( col1, "column-name-dashes" )
    ON TABLE myschema.mytable TO authenticated;
```

#### create policy

```sql
select deparser.expression(
    ast_helpers.create_policy(
        v_policy_name := 'mypolicy'::text,
        v_schema_name := 'myschema'::text,
        v_table_name := 'mytable'::text,
        v_roles := '{app_user, auth_user}'::text[],
        v_qual := ast.bool_expr(
            v_boolop := 'OR_EXPR',
            v_args := to_jsonb(
                ARRAY[
                    ast.a_expr(
                        v_kind := 'AEXPR_OP',
                        v_name := to_jsonb(ARRAY[
                            ast.string('=')
                        ]),
                        v_lexpr := ast.func_call(
                            v_funcname := to_jsonb(ARRAY[
                                ast.string('roles_public'),
                                ast.string('current_role_id')
                            ])
                        ),
                        v_rexpr := ast.column_ref(
                            v_fields := to_jsonb(ARRAY[
                                ast.string('role_id')
                            ])
                        )
                    ),
                    ast.func_call(
                        v_funcname := to_jsonb(ARRAY[
                            ast.string('permissions_private'),
                            ast.string('permitted_on_role')
                        ]),
                        v_args := to_jsonb(ARRAY[
                            ast.column_ref(
                                v_fields := to_jsonb(ARRAY[
                                    ast.string('group_id')
                                ])
                            )
                        ])
                    )
                ]
            )
        ),
        v_cmd_name := 'SELECT'::text,
        v_permissive := false::boolean
    )
);
```

produces

```sql
CREATE POLICY mypolicy ON myschema.mytable AS RESTRICTIVE FOR
SELECT
    TO app_user,
    auth_user USING (
        roles_public.current_role_id() = role_id
        OR permissions_private.permitted_on_role(group_id)
    );
```

#### alter policy

```sql
SELECT deparser.deparse(ast_helpers.alter_policy(
  v_policy_name := 'mypolicy',
  v_schema_name := 'schemanamed',
  v_table_name := 'mytable',
  v_roles := '{authenticated}'::text[],
  v_qual := ast.bool_expr('OR_EXPR', to_jsonb(ARRAY[
    ast.a_expr(v_kind := 'AEXPR_OP',
      v_lexpr := ast.column_ref(
        v_fields := to_jsonb(ARRAY[ ast.string('responder_id') ])
      ),
      v_name := to_jsonb(ARRAY[ast.string('=')]),
      v_rexpr := ast.func_call(
        v_funcname := to_jsonb(ARRAY[ ast.string('dbe'), ast.string('get_uid') ]),
        v_args := to_jsonb(ARRAY[ ast.string('c'), ast.string('b') ])
      )  
    ),
    ast.a_expr(v_kind := 'AEXPR_OP',
      v_lexpr := ast.column_ref(
        v_fields := to_jsonb(ARRAY[ ast.string('requester_id') ])
      ),
      v_name := to_jsonb(ARRAY[ast.string('=')]),
      v_rexpr := ast.func_call(
        v_funcname := to_jsonb(ARRAY[ ast.string('dbe'), ast.string('get_other_uid') ]),
        v_args := to_jsonb(ARRAY[ ast.string('c'), ast.string('b') ])
      )  
    )
  ])),
  v_with_check := NULL
));
```

produces

```sql
ALTER POLICY mypolicy
    ON schemanamed.mytable TO authenticated USING (
    responder_id = dbe.get_uid(c, b)
    OR requester_id = dbe.get_other_uid(c, b)
);
```

#### create trigger

```sql
select
	deparser.deparse(
		ast_helpers.create_trigger(
			v_trigger_name := 'v_trigger_name',
			v_schema_name := 'v_schema_name',
			v_table_name := 'v_table_name',
			v_trigger_fn_schema := 'v_trigger_fn_schema',
			v_trigger_fn_name := 'v_trigger_fn_name',
			v_whenClause := ast.a_expr(
				v_kind := 'AEXPR_DISTINCT',
				v_lexpr := ast.column_ref(
					to_jsonb(ARRAY [ ast.string('old'),ast.string('field-b') ])
				),
				v_name := to_jsonb(ARRAY [ast.string('=')]),
				v_rexpr := ast.column_ref(
					to_jsonb(ARRAY [ ast.string('new'),ast.string('field-b') ])
				)
			),
			v_params := NULL,
			v_timing := 2,
			v_events := 16
		)
	);
```

produces

```sql
CREATE TRIGGER v_trigger_name 
 BEFORE UPDATE ON v_schema_name.v_table_name 
 FOR EACH ROW 
 WHEN (OLD."field-b" IS DISTINCT FROM NEW."field-b") 
 EXECUTE PROCEDURE v_trigger_fn_schema.v_trigger_fn_name ( );
```

### trigger distinct fields

```sql
select deparser.deparse( 
  ast_helpers.create_trigger_distinct_fields(
    v_trigger_name := 'my-trigger',
    v_schema_name := 'my-schema',
    v_table_name := 'my-table',
    v_trigger_fn_schema := 'my-tg-fn-schema',
    v_trigger_fn_name := 'my-tg-fn',  
    v_fields := ARRAY['name', 'description']::text[],
    v_timing := 2,
    v_events := 4 | 16)
  )
 ```

 produces

 ```sql
CREATE TRIGGER "my-trigger" 
 BEFORE INSERT OR UPDATE ON "my-schema"."my-table" 
 FOR EACH ROW 
 WHEN (OLD.name IS DISTINCT FROM NEW.name OR OLD.description IS DISTINCT FROM NEW.description) 
 EXECUTE PROCEDURE "my-tg-fn-schema"."my-tg-fn" ( );
 ```

#### fixtures

```sql
select deparser.deparse(
    ast_helpers.create_fixture(
     	v_schema := 'myschema',
     	v_table := 'mytable',
     	v_cols := '{a,b,c,d}',
     	v_values := '[[{"type":"int","value":1},{"type":"text","value":"textme"},{"type":"float","value":1.3},{"type":"bool","value":true}],[{"type":"int","value":2},{"type":"text","value":"yolo"},{"type":"float","value":1.3},{"type":"bool","value":false}]]'
	)
);
```

produces

```sql
INSERT INTO myschema.mytable (a, b, c, d) VALUES (1, 'textme', 1.3, TRUE), (2, 'yolo', 1.3, FALSE);
```

#### denormalized fields trigger

```sql
SELECT ast_helpers.denormalized_fields_trigger_body (
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',
    v_ref_field := 'v_ref_field',
    v_table_field := 'v_table_field',
    
    v_ref_fields := '{a,b,c}',
    v_set_fields := '{d,e,f}'
);
```

produces

```sql
BEGIN
  IF (NEW.v_table_field IS NOT NULL) THEN
   SELECT ref.a,
ref.b,
ref.c FROM v_schema_name.v_table_name AS ref WHERE ref.v_ref_field = new.v_table_field
   INTO new.d,
new.e,
new.f;
  END IF;
  RETURN NEW;
  END;
```

#### comments

the `smart_comments` helpers is meant for use with [graphile](https://www.graphile.org/postgraphile/), but you can use any comment string

```sql
select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_TABCONSTRAINT',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_table'),
            ast.string('my_constraint')
        ]),
        v_comment := ast_helpers.smart_comments(
			tags := '{"type":"object","props":["id","url","title","tags"]}'::jsonb,
			description := 'my description'
		)
    )
);
```

produces

```sql
COMMENT ON CONSTRAINT my_constraint ON my_schema.my_table IS E'@type object\n@props id\n@props url\n@props title\n@props tags\nmy description'
```

## installation

If you know how to use extensions, or perhaps even just grab the sql and run with it, you can use the bundled extension here [packages/ast/sql](packages/ast/sql). 

To do an automated recursive deploy that automatically installs deps, you can use `sqitch` and `launchql`.
### Recursive Deploy

If you already have `lql` and `sqitch`, simply run this

```sh
createdb launchql
lql deploy --recursive --database launchql --yes --project ast
```

If you don't have them installed, continue below.
## developing
#### Install `psql`

Install `psql` without actually running the database. On mac you can use

`brew install libpq`

Or you can install the full-blown postgres locally, but it is recommended that you shut the service down. You'll be using `psql` to connect to the postgres that runs inside of a docker container.

#### Install `sqitch`

https://sqitch.org/

mac users can use brew 

```
brew install sqitch --with-postgres-support --without-postgresql
```

or for brew sqitch docs: https://github.com/sqitchers/homebrew-sqitch

#### Install `launchql`

You'll want to install [launchql](https://github.com/launchql/launchql) to run `lql` commands

```sh
npm install -g @launchql/cli
```
## testing
### start the postgres db process

Start the postgres docker

```sh
docker-compose up -d
```

### install modules

This command leverages npm to pull some SQL dependencies. 

```sh
yarn install
```

### install testing roles

```sh
psql < ./bootstrap-roles.sql
psql < ./bootstrap-test-roles.sql
```
### install the Postgres extensions

Now install the extensions:

```sh
make install
```

This basically `ssh`s into the postgres instance with the `packages/` folder mounted as a volume, and installs the bundled sql code as pgxn extensions.

### testing

Testing will load all your latest sql changes and create fresh, populated databases for each sqitch module in `packages/`.

For example

```sh
cd ./packages/ast
yarn test:watch
```


## Versions

As of PG 13, PG majors versions maintained will have a matching dedicated major npm version. Only the latest Postgres stable release receives active updates.

Our latest is built with `13-latest` branch from libpg_query

| PostgreSQL Major Version | libpg_query | Status              | npm 
|--------------------------|-------------|---------------------|---------|
| 13                       | 13-latest   | Active development  | `latest`

## Special Thanks and our Community

* [pgsql-parser](https://github.com/pyramation/pgsql-parser)
* [libpg-query-node](https://github.com/pyramation/libpg-query-node)
* [libpg_query](https://github.com/pganalyze/libpg_query)
* [pg_query](https://github.com/lfittl/pg_query)
* [sqitch](https://sqitch.org/)
* [postgraphile](https://www.graphile.org/postgraphile/)
* [launchql](https://github.com/launchql/launchql)