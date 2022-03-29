import { getConnections } from '../../utils';
import cases from 'jest-in-case';

let db, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint();
});
afterAll(async () => {
  try {
    //try catch here allows us to see the sql parsing issues!
    await db.rollback();
    await db.commit();
    await teardown();
  } catch (e) {
    console.log(e);
  }
});

it('geometry', async () => {
  const [result] = await db.any(
    `
        select deparser.deparse(
          ast_helpers.column_geotype_identifier(
            v_column_geo_type := $1::text,
            v_column_geo_num := $2::int
          )
        );
          `,
    ['polygon', 4326]
  );
  expect(result).toMatchSnapshot();
});

it('arrays', async () => {
  const [result] = await db.any(
    `
        select deparser.deparse(
          ast_helpers.alter_table_add_column(
            v_schema_name := 'v_schema_name',
            v_table_name := 'v_table_name',
            v_column_name := 'v_column_name',
            v_column_type := $1::text,
            v_is_array := $2::bool
          )
        );
          `,
    ['uuid', true]
  );
  expect(result).toMatchSnapshot();
});

cases(
  'alter_table_add_column',
  async (opts) => {
    const [result] = await db.any(
      `
        select deparser.deparse( 
          ast_helpers.alter_table_add_column(
            v_schema_name := 'v_schema_name',
            v_table_name := 'v_table_name',
            v_column_name := 'v_column_name',
            v_column_type := $1::text
          )
        );
          `,
      [opts.name]
    );
    expect(result).toMatchSnapshot();
  },
  [
    { name: 'serial' },
    { name: 'bigserial' },
    { name: 'smallserial' },
    { name: 'bytea' },
    { name: 'smallint' },
    { name: 'int' },
    { name: 'bigint' },
    { name: 'char(1)' },
    { name: 'varchar(10)' },
    { name: 'text' },
    { name: 'boolean' },
    { name: 'inet' },
    { name: 'cidr' },
    { name: 'macaddr' },
    { name: 'numeric(1,0)' },
    { name: 'real' },
    { name: 'float(1)' },
    { name: 'float8' },
    { name: 'money' },
    { name: 'tsquery' },
    { name: 'tsvector' },
    { name: 'date' },
    { name: 'time' },
    { name: 'time with time zone' },
    { name: 'timestamp' },
    { name: 'timestamp with time zone' },
    { name: 'interval' },
    { name: 'bit' },
    { name: 'bit(4)' },
    { name: 'varbit' },
    { name: 'varbit(4)' },
    { name: 'box' },
    { name: 'circle' },
    { name: 'lseg' },
    { name: 'path' },
    { name: 'point' },
    { name: 'polygon' },
    { name: 'json' },
    { name: 'xml' },
    { name: 'uuid' },
    //
    { name: 'uuid[]' },
    { name: 'citext' },
    { name: 'geometry(point, 4326)' },
    { name: 'geometry(polygon, 4326)' }
  ]
);

cases(
  'types test',
  async (opts) => {
    const [result] = await db.any(
      `
      select ARRAY_LENGTH(REGEXP_MATCHES($1::text, '\\W'), 1) > 0 as contains;          `,
      [opts.name]
    );
    expect(result).toMatchSnapshot();
  },
  [
    { name: 'serial' },
    { name: 'bigserial' },
    { name: 'smallserial' },
    { name: 'bytea' },
    { name: 'smallint' },
    { name: 'int' },
    { name: 'bigint' },
    { name: 'char(1)' },
    { name: 'varchar(10)' },
    { name: 'text' },
    { name: 'boolean' },
    { name: 'inet' },
    { name: 'cidr' },
    { name: 'macaddr' },
    { name: 'numeric(1,0)' },
    { name: 'real' },
    { name: 'float(1)' },
    { name: 'float8' },
    { name: 'money' },
    { name: 'tsquery' },
    { name: 'tsvector' },
    { name: 'date' },
    { name: 'time' },
    { name: 'time with time zone' },
    { name: 'timestamp' },
    { name: 'timestamp with time zone' },
    { name: 'interval' },
    { name: 'bit' },
    { name: 'bit(4)' },
    { name: 'varbit' },
    { name: 'varbit(4)' },
    { name: 'box' },
    { name: 'circle' },
    { name: 'lseg' },
    { name: 'path' },
    { name: 'point' },
    { name: 'polygon' },
    { name: 'json' },
    { name: 'xml' },
    { name: 'uuid' },
    //
    { name: 'uuid[]' },
    { name: 'citext' },
    { name: 'geometry(point, 4326)' },
    { name: 'geometry(polygon, 4326)' }
  ]
);
