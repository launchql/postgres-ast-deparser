import { getConnections, closeConnections } from '../../utils';
import { initDatabase } from '../../utils/helpers';

let db, conn, dbs, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  dbs = db.helper('collections_public');
});

afterAll(async () => {
  await teardown();
});

beforeEach(async () => {
  await db.beforeEach();
});
afterEach(async () => {
  await db.afterEach();
});

describe('has a database', () => {
  beforeEach(async () => {
    await initDatabase({ objs, dbs });
  });
  describe('fields', () => {
    beforeEach(async () => {
      objs.tables.customer = await dbs.insertOne('table', {
        database_id: objs.database1.id,
        schema_id: objs.database1.schemas.public.id,
        name: 'customers'
      });
    });
    it('can we dump a table by name?', async () => {
      const field = await dbs.insertOne('field', {
        table_id: objs.tables.customer.id,
        name: `id uuid; drop schema "${objs.database1.schema_name}" cascade;`,
        type: 'uuid',
        is_required: true,
        default_value: 'uuid_generate_v4 ()'
      });
      expect(field.name).toEqual(
        `id_uuid_drop_schema_${objs.database1.schema_name.replace(
          /-/g,
          '_'
        )}_cascade`
      );
    });
    it('can we dump a table by type?', async () => {
      let failed = false;
      let message = false;
      try {
        await dbs.insertOne('field', {
          table_id: objs.tables.customer.id,
          name: 'id',
          type: `uuid; drop schema "${objs.database1.schema_name}" cascade;`,
          is_required: true,
          default_value: 'uuid_generate_v4 ()'
        });
      } catch (e) {
        failed = true;
        message = e.message;
      }
      expect(message).toEqual('NONEXISTENT_TYPE');
      expect(failed).toBe(true);
    });
    it('can we dump a table by default_value?', async () => {
      let failed = false;
      let message = false;
      try {
        await dbs.insertOne('field', {
          table_id: objs.tables.customer.id,
          name: 'id',
          type: 'uuid',
          is_required: true,
          default_value: `uuid_generate_v4 (); drop schema "${objs.database1.schema_name}" cascade;`
        });
      } catch (e) {
        failed = true;
        message = e.message;
      }
      expect(message).toEqual('BAD_FIELD_INPUT');
      expect(failed).toBe(true);
    });
  });
});
