import {
  getConnections,
  closeConnections,
} from '../../utils';
import cases from 'jest-in-case';


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

describe('custom database tables', () => {
  beforeEach(async () => {
    ({db, conn} = await getConnections());
    await twoUsersAndProject({ db, conn, objs });
    wrapConn(conn);

  });
  afterEach(async () => {
    await closeConnections({db, conn});
  });
  describe('database basics', () => {
    beforeEach(async () => {
      objs.database1 = await conn.insertOne('collections_public.database', {
        project_id: objs.project1.id,
        name: 'mydb'
      });
    });
    it('can create a database', async () => {
      expect(objs.database1).toBeTruthy();
      expect(objs.database1.id).toBeTruthy();
      await conn.any('SELECT * FROM verify_schema($1)', objs.database1.schema_name);
    });
    describe('tables', () => {
      it('can create a table', async () => {
        objs.tables.customer = await conn.insertOne('collections_public.table', {
          database_id: objs.database1.id,
          name: 'customers'
        });
        expect(objs.tables.customer).toBeTruthy();
        expect(objs.tables.customer.id).toBeTruthy();

        expect(objs.tables.customer.database_id).toEqual(objs.database1.id);
        
        await db.any(
          'SELECT * FROM verify_table($1)',
          `${objs.database1.schema_name}.customers`
        );
      });
    });
  });
});
