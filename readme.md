# PostgreSQL ASTs in PostgreSQL

This project is the plpgsql companion to https://github.com/pyramation/pgsql-parser. A PostgreSQL AST toolkit and deparser, written in pure plpgsql.

## Why?

Because string concatenation is bad, and ASTs are the DNA of software itself.

### a note on compatibility

Written in pure plpgsql so that it can be installed anywhere, including managed RDBMS environments that don't support untrusted extensions.
## Usage

Use the `deparser.deparse()` function to deparse Postgres ASTs, in SQL:

```sql
select deparser.deparse( $1::jsonb );
```

## Examples

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
## installation

If you know how to use extensions, or perhaps even just grab the sql and run with it, you can use the bundled extension here [packages/ast/sql](packages/ast/sql). If you run it manually, you just need to make sure to install the `uuid-ossp` extension. 

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
