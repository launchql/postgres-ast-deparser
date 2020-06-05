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
  tables: {},
};
  
describe('custom database relations', () => {
  beforeEach(async () => {
    ({db, conn} = await getConnections());
    await twoUsersAndProject({ db, conn, objs });
    wrapConn(conn);
    wrapConn(db);
  });
  afterEach(async () => {
    await closeConnections({db, conn});
  });
  describe('has a database', () => {
    beforeEach(async () => {
      objs.database1 = await conn.insertOne('collections_public.database', {
        project_id: objs.project1.id,
        name: 'mydb'
      });
    });
    describe('relations', () => {
      beforeEach(async () => {
        objs.tables.user = await conn.insertOne('collections_public.table', {
          database_id: objs.database1.id,
          name: 'user'
        });
        objs.tables.blog = await conn.insertOne('collections_public.table', {
          database_id: objs.database1.id,
          name: 'blog'
        });
   
        // IDS
        objs.field1 = await conn.insertOne('collections_public.field', {
          table_id: objs.tables.user.id,
          name: 'id',
          type: 'uuid',
          is_required: true,
          default_value: 'uuid_generate_v4 ()'
        });
        objs.field2 = await conn.insertOne('collections_public.field', {
          table_id: objs.tables.blog.id,
          name: 'id',
          type: 'uuid',
          is_required: true,
          default_value: 'uuid_generate_v4 ()'
        });

        // fields
        objs.field3 = await conn.insertOne('collections_public.field', {
          table_id: objs.tables.user.id,
          name: 'username',
          type: 'text',
        });
  
        objs.field4 = await conn.insertOne('collections_public.field', {
          table_id: objs.tables.blog.id,
          name: 'author_id',
          type: 'uuid',
        });
      });
      it('can create a unique constraint', async () => {
        objs.unique1 = await conn.insertOne('collections_public.unique_constraint', {
          table_id: objs.tables.user.id,
          name: 'username_idx',
          type: 'u',
          field_ids: [objs.field3.id]
        }, {
          field_ids: 'uuid[]'
        });
        expect(objs.unique1).toBeTruthy();
      });
      it('can create a primary key constraint', async () => {
        objs.primary1 = await conn.insertOne('collections_public.primary_key_constraint', {
          table_id: objs.tables.user.id,
          name: 'pkey_users',
          type: 'p',
          field_ids: [objs.field1.id]
        }, {
          field_ids: 'uuid[]'
        });
        expect(objs.primary1).toBeTruthy();
      });
      it('can create a foreign key constraint with no action', async () => {
        await conn.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [objs.tables.user.id, 'pkey_users', 'p', [objs.field1.id]]
        );
  
        await conn.any(
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
          [objs.tables.blog.id, 'fk_owners', 'f', objs.field4.id, objs.tables.user.id, objs.field1.id, 'a', 'a']
        );
      });
      it('can create a foreign key constraint with action options', async () => {
        await conn.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [objs.tables.user.id, 'pkey_users', 'p', [objs.field1.id]]
        );
  
        await conn.any(
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
          [objs.tables.blog.id, 'fk_owners', 'f', objs.field4.id, objs.tables.user.id, objs.field1.id, 'c', 'r']
        );
      });
      it('can create a multi primary key constraint', async () => {
        await conn.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [objs.tables.user.id, 'pkey_users', 'p', [objs.field1.id]]
        );
        await conn.any(
          `insert into collections_public.primary_key_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [objs.tables.blog.id, 'pkey_blogs', 'p', [objs.field2.id, objs.field4.id]]
        );
      });
      it('can create a multi unique constraint', async () => {
        await conn.any(
          `insert into collections_public.unique_constraint 
                  (table_id, name, type, field_ids) 
                  values ($1, $2, $3, $4::uuid[]) 
                  RETURNING *`,
          [objs.tables.blog.id, 'pkey_blogs', 'p', [objs.field2.id, objs.field4.id]]
        );
      });
    });
  });
});
  