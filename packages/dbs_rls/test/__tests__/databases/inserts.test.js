import {
  getConnections,
  closeConnections,
} from '../../utils';

import {
  twoUsersAndProject
} from '../../utils/projects';

import {
  wrapConn
} from '../../utils/db';


let db, conn;
let objs = {
  tables: {}
};

describe('custom database inserts', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    await twoUsersAndProject({ db, conn, objs });
    wrapConn(conn);
    wrapConn(db);
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('has a database', () => {
    beforeEach(async () => {
      objs.database1 = await conn.insertOne('collections_public.database', {
        project_id: objs.project1.id,
        name: 'mydb'
      });
      objs.tables.customer = await conn.insertOne('collections_public.table', {
        database_id: objs.database1.id,
        name: 'customers'
      });
      await conn.insertOne('collections_public.field', {
        table_id: objs.tables.customer.id,
        name: 'id',
        type: 'uuid',
        is_required: true,
        default_value: 'uuid_generate_v4 ()'
      });

      await conn.insertOne('collections_public.field', {
        table_id: objs.tables.customer.id,
        name: 'name',
        type: 'text'
      });

    });
    describe('can add fields', () => {
      it('postgres user can insert data', async () => {
        await db.any(
          `INSERT INTO "${
            objs.database1.schema_name
          }".customers (name) VALUES ('dan'), ('jobs')`
        );
        const customers = await db.any(
          `SELECT id, name FROM "${objs.database1.schema_name}".customers`
        );
        expect(customers).toBeTruthy();
        expect(customers.length).toBe(2);
      });
      it('can insert data', async () => {
        await conn.any(
          `INSERT INTO "${
            objs.database1.schema_name
          }".customers (name) VALUES ('dan'), ('jobs')`
        );
        const customers = await conn.any(
          `SELECT id, name FROM "${objs.database1.schema_name}".customers`
        );
        expect(customers).toBeTruthy();
        expect(customers.length).toBe(2);
      });
    });
  });
});
