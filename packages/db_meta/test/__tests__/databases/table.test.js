import { getConnections, closeConnections } from '../../utils';
import cases from 'jest-in-case';
import { initDatabase } from '../../utils/helpers';

let db, conn, dbs, teardown;
const objs = {};

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

describe('database basics', () => {
  beforeEach(async () => {
    await initDatabase({ objs, dbs });
  });
  it('can create a database', async () => {
    expect(objs.database1).toBeTruthy();
    expect(objs.database1.id).toBeTruthy();
    await db.any('SELECT * FROM verify_schema($1)', objs.database1.schema_name);
  });
  describe('tables', () => {
    it('can create a table', async () => {
      const customer = await dbs.insertOne('table', {
        database_id: objs.database1.id,
        schema_id: objs.database1.schemas.public.id,
        name: 'customers'
      });

      expect(customer).toBeTruthy();
      expect(customer.id).toBeTruthy();
      await db.any(
        'SELECT * FROM verify_table($1)',
        `"${objs.database1.schema_name}".customers`
      );
    });
    describe('naming conventions', () => {
      it('table names are snake_case', async () => {
        const table = await dbs.insertOne('table', {
          database_id: objs.database1.id,
          schema_id: objs.database1.schemas.public.id,
          name: 'UserLogin'
        });
        expect(table.name).toEqual('user_login');
        expect(table.plural_name).toEqual('user_logins');
        expect(table.singular_name).toEqual('user_login');
      });
      it('tables have singular/plural_name logic', async () => {
        const table = await dbs.insertOne('table', {
          database_id: objs.database1.id,
          schema_id: objs.database1.schemas.public.id,
          name: 'user_login'
        });

        expect(table.name).toEqual('user_login');
        expect(table.plural_name).toEqual('user_logins');
        expect(table.singular_name).toEqual('user_login');
      });
      cases(
        'reserved words',
        async (opts) => {
          let failed = false;
          let message = '';
          try {
            await db.any(
              'insert into collections_public.table (database_id, schema_id, name) values ($1, $2, $3) RETURNING *',
              [objs.database1.id, objs.database1.schemas.public.id, opts.name]
            );
          } catch (e) {
            failed = true;
            message = e.message;
          }
          expect(failed).toBe(true);
          expect(message).toEqual('DATABASE_TABLE_RESERVED_WORD');
        },
        [
          { name: 'nodes' },
          { name: 'mutations' },
          { name: 'subscriptions' },
          { name: 'queries' }
        ]
      );
    });
  });
});
