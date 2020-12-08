import { getConnections } from '../../../utils';
import { initDatabase } from '../../../utils/helpers';
import { snapshot } from '../../../utils/snaps';
import { Schema } from 'pg-query-string';

const schema = new Schema('collections_public');
const table = schema.table('table', {
  id: 'uuid'
});
const field = schema.table('field', {
  id: 'uuid'
});
const check_constraint = schema.table('check_constraint', {
  id: 'uuid',
  field_ids: 'uuid[]',
  expr: 'jsonb'
});

let db, conn, dbs, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  dbs = db.helper('collections_public');
});
afterAll(async () => {
  try {
    await teardown();
  } catch (e) {
    console.log(e);
  }
});
beforeEach(async () => {
  await db.beforeEach();
  await initDatabase({ objs, dbs });
});
afterEach(async () => {
  await db.afterEach();
});

const getOne = async (query) => {
  return await db.one(query.text, query.values);
};
const get = async (query) => {
  return await db.any(query.text, query.values);
};

beforeEach(async () => {
  objs.tables.user = await getOne(
    table.insert({
      database_id: objs.database1.id,
      schema_id: objs.database1.schemas.public.id,
      name: 'user'
    })
  );
  objs.tables.user.fields = {};
  objs.tables.user.fields.id = await getOne(
    field.insert({
      table_id: objs.tables.user.id,
      name: 'id',
      type: 'uuid',
      is_required: true,
      default_value: 'uuid_generate_v4 ()'
    })
  );
  objs.tables.user.fields.username = await getOne(
    field.insert({
      table_id: objs.tables.user.id,
      name: 'username',
      type: 'text',
      min: 3,
      max: 20,
      regexp: '^[A-Za-z0-9_-]+$'
    })
  );
  objs.tables.user.fields.reputation = await getOne(
    field.insert({
      table_id: objs.tables.user.id,
      name: 'reputation',
      type: 'integer',
      min: 3,
      max: 20
    })
  );
});

const checkChecks = async (table_id) => {
  const checks = await get(
    check_constraint.select(['*'], {
      table_id
    })
  );
  for (const c of checks) {
    if (c.expr) {
      const [
        { expression: result }
      ] = await db.any(`select deparser.expression( $1::jsonb );`, [c.expr]);
      console.log(result);
      expect(snapshot(result)).toMatchSnapshot();
    }
  }
};

it('can create a check constraint', async () => {
  await checkChecks(objs.tables.user.id);
});

it('check updates', async () => {
  await get(
    field.update(
      {
        min: 3,
        max: 22
      },
      {
        table_id: objs.tables.user.id,
        name: 'reputation'
      }
    )
  );
  await checkChecks(objs.tables.user.id);
});

it('check updates w null', async () => {
  await get(
    field.update(
      {
        min: 3,
        max: null
      },
      {
        table_id: objs.tables.user.id,
        name: 'reputation'
      }
    )
  );
  await checkChecks(objs.tables.user.id);
  await get(
    field.update(
      {
        min: null
      },
      {
        table_id: objs.tables.user.id,
        name: 'reputation'
      }
    )
  );
  await checkChecks(objs.tables.user.id);
  await get(
    field.update(
      {
        min: null,
        max: null,
        regexp: null
      },
      {
        table_id: objs.tables.user.id,
        name: 'username'
      }
    )
  );
  await checkChecks(objs.tables.user.id);
  await get(
    field.update(
      {
        regexp: '^[A-Za-z]+$'
      },
      {
        table_id: objs.tables.user.id,
        name: 'username'
      }
    )
  );
  await checkChecks(objs.tables.user.id);
});
