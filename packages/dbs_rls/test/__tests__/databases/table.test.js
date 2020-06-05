import {
  getConnections,
  closeConnections,
} from '../../utils';
import cases from 'jest-in-case';

const v4 = require('uuid').v4;

let db, conn, database;

describe('custom database tables', () => {
  beforeEach(async () => {
    ({db, conn} = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({db, conn});
  });
  describe('database basics', () => {
    beforeEach(async () => {
      [database] = await db.any(
        'insert into collections_public.database (tenant_id, name) values ($1, \'mydb\') RETURNING *',
        v4()
      );
    });
    it('can create a database', async () => {
      expect(database).toBeTruthy();
      expect(database.id).toBeTruthy();
      await db.any('SELECT * FROM verify_schema($1)', database.schema_name);
    });
    describe('tables', () => {
      it('can create a table', async () => {
        const [customer] = await db.any(
          'insert into collections_public.table (database_id, name) values ($1, $2) RETURNING *',
          [database.id, 'customers']
        );
        expect(customer).toBeTruthy();
        expect(customer.id).toBeTruthy();
        await db.any(
          'SELECT * FROM verify_table($1)',
          `${database.schema_name}.customers`
        );
      });
      describe('naming conventions', () => {
        it('table names are snake_case', async () => {
          const [table] = await db.any(
            'insert into collections_public.table (database_id, name) values ($1, $2) RETURNING *',
            [database.id, 'UserLogin']
          );
          expect(table.name).toEqual('user_login');
          expect(table.plural_name).toEqual('user_logins');
          expect(table.singular_name).toEqual('user_login');
        });
        it('tables have singular/plural_name logic', async () => {
          const [table] = await db.any(
            'insert into collections_public.table (database_id, name) values ($1, $2) RETURNING *',
            [database.id, 'user_login']
          );
          expect(table.name).toEqual('user_login');
          expect(table.plural_name).toEqual('user_logins');
          expect(table.singular_name).toEqual('user_login');
        });
        cases('reserved words', async opts => {
          let failed = false;
          let message = '';
          try {
            await db.any(
              'insert into collections_public.table (database_id, name) values ($1, $2)',
              [database.id, opts.name]
            );
          } catch (e) {
            failed = true;
            message = e.message;
          }
          expect(failed).toBe(true);
          expect(message).toEqual('DATABASE_TABLE_RESERVED_WORD');
        }, [
          { name: 'nodes' },
          { name: 'mutations' },
          { name: 'subscriptions' },
          { name: 'queries' },
        ]);
      });
    });
  });
});
