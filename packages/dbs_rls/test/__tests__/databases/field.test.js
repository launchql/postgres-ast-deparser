import {
  getConnections,
  closeConnections,
} from '../../utils';

const v4 = require('uuid').v4;

let db, conn, database;

describe('custom database fields', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  describe('has a database', () => {
    beforeEach(async () => {
      [database] = await db.any(
        'insert into collections_public.database (tenant_id, name) values ($1, \'mydb\') RETURNING *',
        v4()
      );
    });
    describe('fields', () => {
      let customer;
      beforeEach(async () => {
        [customer] = await db.any(
          'insert into collections_public.table (database_id, name) values ($1, $2) RETURNING *',
          [database.id, 'customers']
        );
      });
      it('can create a field', async () => {
        await db.any(
          `insert into collections_public.field 
            (table_id, name, type, is_required, default_value) 
            values 
            ($1, $2, $3, $4, $5) RETURNING *`,
          [customer.id, 'id', 'uuid', true, 'uuid_generate_v4 ()']
        );
        const [nameField] = await db.any(
          'insert into collections_public.field (table_id, name, type) values ($1, $2, $3) RETURNING *',
          [customer.id, 'name', 'text']
        );
        expect(nameField).toBeTruthy();
        expect(nameField.id).toBeTruthy();
        await db.any(
          `INSERT INTO "${
            database.schema_name
          }".customers (name) VALUES ('dan'), ('jobs')`
        );
        const customers = await db.any(
          `SELECT id, name FROM "${database.schema_name}".customers`
        );
        expect(customers).toBeTruthy();
        expect(customers.length).toBe(2);
      });
      describe('naming conventions', () => {
        it('field names are snake_case', async () => {
          await db.any(
            `insert into collections_public.field 
              (table_id, name, type, is_required, default_value) 
              values 
              ($1, $2, $3, $4, $5) RETURNING *`,
            [customer.id, 'id', 'uuid', true, 'uuid_generate_v4 ()']
          );
          await db.any(
            'insert into collections_public.field (table_id, name, type) values ($1, $2, $3)',
            [customer.id, 'firstName', 'text']
          );
          await db.any(
            'insert into collections_public.field (table_id, name, type) values ($1, $2, $3)',
            [customer.id, 'LastName', 'text']
          );

          await db.any(
            `INSERT INTO "${
              database.schema_name
            }".customers(first_name, last_name) VALUES ('dan', 'lynch'), ('steve', 'jobs')`
          );
          const customers = await db.any(
            `SELECT id, first_name, last_name FROM "${database.schema_name}".customers`
          );
          expect(customers).toBeTruthy();
          expect(customers.length).toBe(2);
        });
      });
      describe('hidden fields', () => {
        it('field names are snake_case', async () => {
          await db.any(
            `insert into collections_public.field 
              (table_id, name, type, is_required, default_value) 
              values 
              ($1, $2, $3, $4, $5) RETURNING *`,
            [customer.id, 'id', 'uuid', true, 'uuid_generate_v4 ()']
          );
          await db.any(
            'insert into collections_public.field (table_id, name, type) values ($1, $2, $3)',
            [customer.id, 'firstName', 'text']
          );
          await db.any(
            'insert into collections_public.field (table_id, name, type) values ($1, $2, $3)',
            [customer.id, 'LastName', 'text']
          );
          await db.any(
            'insert into collections_public.field (table_id, name, type, is_hidden) values ($1, $2, $3, $4)',
            [customer.id, 'password', 'text', true]
          );

          await db.any(
            `INSERT INTO "${
              database.schema_name
            }".customers(first_name, last_name) VALUES ('dan', 'lynch'), ('steve', 'jobs')`
          );
          const customers = await db.any(
            `SELECT id, first_name, last_name FROM "${database.schema_name}".customers`
          );
          const {get_column_smart_comment} = await db.one(
            `
            SELECT * FROM db_utils.get_column_smart_comment(
              $1,
              $2,
              $3
            )
            `, [database.schema_name, 'customers', 'password']
          );
          expect(get_column_smart_comment).toEqual('@omit');
          expect(customers).toBeTruthy();
          expect(customers.length).toBe(2);
        });
      });
    });
  });
});
