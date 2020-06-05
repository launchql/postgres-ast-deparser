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

describe('custom database fields', () => {
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
    });
    describe('can add fields', () => {
      it('can create a field', async () => {
        await conn.insertOne('collections_public.field', {
          table_id: objs.tables.customer.id,
          name: 'id',
          type: 'uuid',
          is_required: true,
          default_value: 'uuid_generate_v4 ()'
        });

        const nameField = await conn.insertOne('collections_public.field', {
          table_id: objs.tables.customer.id,
          name: 'name',
          type: 'text'
        });

        expect(nameField).toBeTruthy();
        expect(nameField.id).toBeTruthy();
      });
    });
    describe('can NOT add fields', () => {
      it('can create a field', async () => {
        let failed = false;
        conn.setContext({
          role: 'authenticated',
          'jwt.claims.role_id': objs.user2.id
        });
        try {

          await conn.insertOne('collections_public.field', {
            table_id: objs.tables.customer.id,
            name: 'id',
            type: 'uuid',
            is_required: true,
            default_value: 'uuid_generate_v4 ()'
          });
        } catch (e) {
          failed = true;
        }
        expect(failed).toBe(true);
      });
    });
  });
});
