import { getConnections } from '../../utils';

let db, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint();
});
afterAll(async () => {
  try {
    //try catch here allows us to see the sql parsing issues!
    await db.rollback();
    await db.commit();
    await teardown();
  } catch (e) {}
});

const getPolicyResult = async (name, vars) => {
  const [{ deparse }] = await db.any(
    `
  SELECT deparser.deparse(
    ast_helpers.create_policy_template(
      $1::text,
      $2::jsonb
    ))`,
    [name, JSON.stringify(vars)]
  );

  return deparse;
};

it('acl_exists', async () => {
  const result = await getPolicyResult('acl_exists', {
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it('acl_exists mask', async () => {
  const result = await getPolicyResult('acl_exists', {
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    mask: '1010101111'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field w/acl_sel_field', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_sel_field: 'actor_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field include user', async () => {
  const result = await getPolicyResult('acl_field', {
    include_current_user_id: true,
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field_mask', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    mask: '1010010100101010111111'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field_mask include user', async () => {
  const result = await getPolicyResult('acl_field', {
    include_current_user_id: true,
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    mask: '1010010100101010111111'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field_join', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    obj_schema: 'obj_schema',
    obj_table: 'obj_table',
    obj_field: 'group_id'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field_join w/acl_sel_field + acl_join_field', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'owner_id',
    acl_sel_field: 'actor_id',
    acl_join_field: 'joiner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    obj_schema: 'obj_schema',
    obj_table: 'obj_table',
    obj_field: 'group_id'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field_join include user', async () => {
  const result = await getPolicyResult('acl_field_join', {
    include_current_user_id: true,
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    obj_schema: 'obj_schema',
    obj_table: 'obj_table',
    obj_field: 'group_id'
  });
  expect(result).toMatchSnapshot();
});

it('acl_field_join_mask', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    obj_schema: 'obj_schema',
    obj_table: 'obj_table',
    obj_field: 'group_id',
    mask: '1010010100101010111111'
  });
  expect(result).toMatchSnapshot();
});
