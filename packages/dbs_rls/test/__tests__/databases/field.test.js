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
    });
    describe('fields', () => {
      beforeEach(async () => {
        objs.tables.customer = await conn.one(
          'insert into collections_public.table (database_id, name) values ($1, $2) RETURNING *',
          [objs.database1.id, 'customers']
        );
      });
      it('can create a field', async () => {
        await conn.any(
          `insert into collections_public.field 
            (table_id, name, type, is_required, default_value) 
            values 
            ($1, $2, $3, $4, $5) RETURNING *`,
          [objs.tables.customer.id, 'id', 'uuid', true, 'uuid_generate_v4 ()']
        );
        const [nameField] = await conn.any(
          'insert into collections_public.field (table_id, name, type) values ($1, $2, $3) RETURNING *',
          [objs.tables.customer.id, 'name', 'text']
        );
        expect(nameField).toBeTruthy();
        expect(nameField.id).toBeTruthy();
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
