import cases from 'jest-in-case';
import { getConnections, closeConnections } from '../../utils';
import { initDatabase } from '../../utils/helpers';

let db, conn, dbs, teardown;
const objs = {};

// sources: https://www.postgresql.org/docs/9.5/datatype.html
// postgres.git/src/test/modules/test_ddl_deparse/sql/create_table.sql

beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  dbs = db.helper('collections_public');

  await db.begin();
  await db.savepoint('db');
  await initDatabase({ objs, dbs });
  objs.customer = await dbs.insertOne('table', {
    database_id: objs.database1.id,
    schema_id: objs.database1.schemas.public.id,
    name: 'customer'
  });
});

afterAll(async () => {
  await db.rollback('db');
  await db.commit();
  await teardown();
});

beforeEach(async () => {
  await db.savepoint('each');
});
afterEach(async () => {
  await db.rollback('each');
});

cases(
  'reserved words',
  async (opts) => {
    let failed = false;
    let message = '';
    try {
      await dbs.insert('field', {
        table_id: objs.customer.id,
        name: opts.name,
        type: 'text'
      });
    } catch (e) {
      failed = true;
      message = e.message;
    }
    expect(failed).toBe(true);
    expect(message).toEqual('DATABASE_FIELD_RESERVED_WORD');
  },
  [{ name: 'orderBy' }, { name: 'PrimaryKey' }]
);

cases(
  'bad types',
  async (opts) => {
    let failed = false;
    let message = '';
    try {
      await dbs.insert('field', {
        table_id: objs.customer.id,
        name: opts.name,
        type: opts.type
      });
    } catch (e) {
      failed = true;
      message = e.message;
    }
    expect(failed).toBe(true);
    expect(message).toEqual('NONEXISTENT_TYPE');
    // expect(message).toEqual(`type "${opts.type}" does not exist`);
  },
  [
    { name: 'field1', type: 'nonexistent' },
    { name: 'field2', type: 'timestamp with timezone' },
    { name: 'field3', type: 'time with timezone' },
    { name: 'field3', type: 'variable char' }
  ]
);

cases(
  'good types',
  async (opts) => {
    let failed = false;
    try {
      await dbs.insert('field', {
        table_id: objs.customer.id,
        name: opts.name,
        type: opts.type
      });
    } catch (e) {
      console.log(e);
      failed = true;
    }
    expect(failed).toBe(false);
  },
  [
    { name: 'seq_serial', type: 'serial' },
    { name: 'seq_bigserial', type: 'bigserial' },
    { name: 'seq_smallserial', type: 'smallserial' },
    { name: 'regtype_bytea', type: 'bytea' },
    { name: 'regtype_smallint', type: 'smallint' },
    { name: 'regtype_int', type: 'int' },
    { name: 'regtype_bigint', type: 'bigint' },
    { name: 'regtype_char', type: 'char(1)' },
    { name: 'regtype_varchar', type: 'varchar(10)' },
    { name: 'regtype_text', type: 'text' },
    { name: 'regtype_bool', type: 'boolean' },
    { name: 'regtype_inet', type: 'inet' },
    { name: 'regtype_cidr', type: 'cidr' },
    { name: 'regtype_macaddr', type: 'macaddr' },
    { name: 'regtype_numeric', type: 'numeric(1,0)' },
    { name: 'regtype_real', type: 'real' },
    { name: 'regtype_float', type: 'float(1)' },
    { name: 'regtype_float8', type: 'float8' },
    { name: 'regtype_money', type: 'money' },
    { name: 'regtype_tsquery', type: 'tsquery' },
    { name: 'regtype_tsvector', type: 'tsvector' },
    { name: 'regtype_date', type: 'date' },
    { name: 'regtype_time', type: 'time' },
    { name: 'regtype_time_tz', type: 'time with time zone' },
    { name: 'regtype_timestamp', type: 'timestamp' },
    { name: 'regtype_timestamp_tz', type: 'timestamp with time zone' },
    { name: 'regtype_interval', type: 'interval' },
    { name: 'regtype_bit', type: 'bit' },
    { name: 'regtype_bit4', type: 'bit(4)' },
    { name: 'regtype_varbit', type: 'varbit' },
    { name: 'regtype_varbit4', type: 'varbit(4)' },
    { name: 'regtype_box', type: 'box' },
    { name: 'regtype_circle', type: 'circle' },
    { name: 'regtype_lseg', type: 'lseg' },
    { name: 'regtype_path', type: 'path' },
    { name: 'regtype_point', type: 'point' },
    { name: 'regtype_polygon', type: 'polygon' },
    { name: 'regtype_json', type: 'json' },
    { name: 'regtype_xml', type: 'xml' },
    { name: 'regtype_uuid', type: 'uuid' }
  ]
);
