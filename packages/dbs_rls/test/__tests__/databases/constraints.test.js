import {
  getConnections,
  closeConnections,
} from '../../utils';
  
const v4 = require('uuid').v4;
  
let db, conn, database;
  
describe('custom database relations', () => {
  beforeEach(async () => {
    ({db, conn} = await getConnections());
  });
  afterEach(async () => {
    await closeConnections({db, conn});
  });
  describe('has a database', () => {
    beforeEach(async () => {
      [database] = await db.any(
        'insert into collections_public.database (tenant_id, name) values ($1, \'mydb\') RETURNING *',
        v4()
      );
    });
    describe('relations', () => {
      let user, blog, field1, field2, field3, field4;
      
      beforeEach(async () => {
        [user] = await db.any(
          'insert into collections_public.table (database_id, name) values ($1, $2) RETURNING *',
          [database.id, 'user']
        );
        [blog] = await db.any(
          'insert into collections_public.table (database_id, name) values ($1, $2) RETURNING *',
          [database.id, 'blog']
        );
  
        // IDS
        [field1] = await db.any(
          `insert into collections_public.field 
              (table_id, name, type, is_required, default_value) 
              values 
              ($1, $2, $3, $4, $5) RETURNING *`,
          [user.id, 'id', 'uuid', true, 'uuid_generate_v4 ()']
        );
  
        [field2] = await db.any(
          `insert into collections_public.field 
              (table_id, name, type, is_required, default_value) 
              values 
              ($1, $2, $3, $4, $5) RETURNING *`,
          [blog.id, 'id', 'uuid', true, 'uuid_generate_v4 ()']
        );
  
        [field3] = await db.any(
          'insert into collections_public.field (table_id, name, type) values ($1, $2, $3) RETURNING *',
          [user.id, 'username', 'text']
        );
  
        [field4] = await db.any(
          'insert into collections_public.field (table_id, name, type) values ($1, $2, $3) RETURNING *',
          [blog.id, 'author_id', 'uuid']
        );
      });
      it('can create a unique constraint', async () => {
        await db.any(
          `insert into collections_public.unique_constraint 
                (table_id, name, type, field_ids) 
                values ($1, $2, $3, $4::uuid[]) 
                RETURNING *`,
          [user.id, 'username_idx', 'u', [field3.id]]
        );
      });
      it('can create a primary key constraint', async () => {
        await db.any(
          `insert into collections_public.primary_key_constraint 
                (table_id, name, type, field_ids) 
                values ($1, $2, $3, $4::uuid[]) 
                RETURNING *`,
          [user.id, 'pkey_users', 'p', [field1.id]]
        );
      });
      it('can create a foreign key constraint with no action', async () => {
        await db.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [user.id, 'pkey_users', 'p', [field1.id]]
        );
  
        await db.any(
          `insert into collections_public.foreign_key_constraint 
                (
                    table_id,
                    name,
                    type,
                    field_id,
                    ref_table_id,
                    ref_field_id,
                    delete_action,
                    update_action
                ) 
                values ($1, $2, $3, $4, $5, $6, $7, $8) 
                RETURNING *`,
          [blog.id, 'fk_owners', 'f', field4.id, user.id, field1.id, 'a', 'a']
        );
      });
      it('can create a foreign key constraint with action options', async () => {
        await db.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [user.id, 'pkey_users', 'p', [field1.id]]
        );
  
        await db.any(
          `insert into collections_public.foreign_key_constraint 
                (
                    table_id,
                    name,
                    type,
                    field_id,
                    ref_table_id,
                    ref_field_id,
                    delete_action,
                    update_action
                ) 
                values ($1, $2, $3, $4, $5, $6, $7, $8) 
                RETURNING *`,
          [blog.id, 'fk_owners', 'f', field4.id, user.id, field1.id, 'c', 'r']
        );
      });
      it('can create a multi primary key constraint', async () => {
        await db.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [user.id, 'pkey_users', 'p', [field1.id]]
        );
        await db.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [blog.id, 'pkey_blogs', 'p', [field2.id, field4.id]]
        );
      });
      it('can create a multi unique constraint', async () => {
        await db.any(
          `insert into collections_public.unique_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [blog.id, 'pkey_blogs', 'p', [field2.id, field4.id]]
        );
      });
    });
  });
});
  