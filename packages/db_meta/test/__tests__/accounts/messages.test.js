import { Schema, Query } from 'pg-query-string';
import * as ast from 'pg-ast';
import { getConnections } from '../../utils';
import initObjects from '../../utils/generic';
import { assertFailureWithTx } from '../../utils/assertions';
import { snap } from '../../utils/snaps';
import {
  USER_TABLE,
  GET_CURRENT_ROLE_ID,
  GET_CURRENT_GROUP_IDS
} from '../../utils/generic';
import {
  makeApi,
  str,
  funcCall,
  any,
  and,
  or,
  equals,
  col
} from '../../utils/helpers';

let db, api, teardown;
const objs = {
  tables: {}
};

let qString;
let query;

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  await initObjects({ objs, db });
  query = new Query({ client: db, type: 1 });
  api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
  qString = {
    public: new Schema(objs.database1.schema_name),
    private: new Schema(objs.database1.private_schema_name)
  };
});

afterAll(async () => {
  try {
    await db.rollback('db');
    await db.commit();
    await teardown();
  } catch (e) {
    console.log(e);
  }
});

beforeEach(async () => {
  db.setContext({
    role: 'anonymous'
  });
  const [user1] = await api.public.callAny('register', {
    email: 'pyramation@gmail.com',
    password: 'password'
  });
  const [user2] = await api.public.callAny('register', {
    email: 'd@nlynch.com',
    password: 'password'
  });
  const [user3] = await api.public.callAny('register', {
    email: 'dan@nlynch.com',
    password: 'password'
  });
  objs.enduser1 = user1;
  objs.enduser2 = user2;
  objs.enduser3 = user3;
  snap(objs.enduser1);

  // INIT messages
  const dbs = db.helper('collections_public');
  const {
    enablePeopleStamps,
    enableTimestamps,
    addIndex,
    addForeignKey,
    addUnique,
    addTimestamps,
    addPeopleStamps,
    createTable,
    createThroughTable,
    applyRLS,
    addFullTextSearch,
    addIndexMigration,
    slugifyField,
    statusTrigger,
    ownedFieldInSharedObject
  } = makeApi({ objs, dbs, db });

  const rlsFn = (group = false) => {
    return ast.FuncCall({
      funcname: [
        str(objs.database1.schemas.public.schema_name),
        str(group ? GET_CURRENT_GROUP_IDS : GET_CURRENT_ROLE_ID)
      ]
    });
  };

  db.setContext({
    role: 'postgres'
  });

  // message_groups
  await createTable({
    name: 'message_groups',
    fields: [
      {
        name: 'name',
        type: 'text'
      },
      {
        name: 'member_ids',
        type: 'uuid[]'
      }
    ]
  });

  await addIndex({ table_name: 'message_groups', field_names: ['member_ids'] });

  await applyRLS({
    table_name: 'message_groups',
    privs: [
      ['insert', 'authenticated'],
      ['update', 'authenticated'],
      ['select', 'authenticated'],
      ['delete', 'authenticated'] // TODO only if cardinality = 2
    ],
    policy_template_name: 'ast',
    policy_template_vars: any(rlsFn(), col('member_ids'))
  });

  // messages
  await createTable({
    name: 'messages',
    fields: [
      {
        name: 'type',
        type: 'text',
        is_required: true,
        default_value: "'text'"
      },
      {
        name: 'content',
        type: 'jsonb'
      },
      {
        name: 'upload',
        type: 'upload'
      }
    ]
  });
  await addForeignKey({
    table_name: 'messages',
    field_name: 'sender_id',
    ref_table: USER_TABLE,
    index: true,
    is_required: true
  });
  await addForeignKey({
    table_name: 'messages',
    field_name: 'group_id',
    ref_table: 'message_groups',
    index: true,
    is_required: true
  });

  await applyRLS({
    table_name: 'messages',
    privs: [
      ['insert', 'authenticated'], // technically the sender needs to insert only!
      ['update', 'authenticated'],
      ['select', 'authenticated'],
      ['delete', 'authenticated']
    ],
    policy_template_name: 'owned_object_records_group_array',
    policy_template_vars: {
      owned_table_key: 'member_ids',
      owned_schema: objs.database1.schemas.public.schema_name,
      owned_table: 'message_groups',
      owned_table_ref_key: 'id', // groups_pkey
      this_object_key: 'group_id'
    }
  });
});

const send = async ({ sender_id, group_id, message }) => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': sender_id
  });
  return await query.query(
    qString.public
      .table('messages', {
        group_id: 'uuid',
        content: 'jsonb'
      })
      .insert({
        group_id,
        sender_id,
        type: 'text',
        content: JSON.stringify(message)
      })
  );
};

const read = async (user_id) => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': user_id
  });
  const Messages = qString.public.table('messages', {
    group_id: 'uuid',
    content: 'jsonb'
  });
  const messages = await query.query(Messages.select(['*']));
  return messages;
};

it('create group', async () => {
  const Groups = qString.public.table('message_groups', {
    member_ids: 'uuid[]'
  });

  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const groups = await query.query(
    Groups.insert({
      member_ids: [objs.enduser1.user_id, objs.enduser2.user_id],
      name: 'heaven is here'
    })
  );
  snap(groups);

  await send({
    group_id: groups[0].id,
    sender_id: objs.enduser1.user_id,
    message: 'hello world'
  });
  await send({
    group_id: groups[0].id,
    sender_id: objs.enduser2.user_id,
    message: 'oh hi'
  });

  const read1 = await read(objs.enduser1.user_id);
  const read2 = await read(objs.enduser2.user_id);
  const read3 = await read(objs.enduser3.user_id);
  snap(read1);
  snap(read2);
  snap(read3);
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  await query.query(
    Groups.update(
      {
        // BUG update pg-query-string
        // updates need double [[]]
        member_ids: [
          [objs.enduser1.user_id, objs.enduser2.user_id, objs.enduser3.user_id]
        ]
      },
      {
        id: groups[0].id
      }
    )
  );
  const read4 = await read(objs.enduser3.user_id);
  snap(read4);
});
