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

// wait, can't we just use groups ACL?
// imagine that you have groups, but there was no groups ACL table!
/*

create table groups (
  id uuid,
  name text
);

create table group_message (
  group_id uuid,
  name text
);

*/

it('group_messages via once-removed owned object', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'group_id',
    sel_obj: true,
    sel_field: 'id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    obj_schema: 'pub',
    obj_table: 'groups',
    obj_field: 'owner_id'
  });
  expect(result).toMatchSnapshot();
});

it('group_messages via groups ACL', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'group_id',
    sel_obj: false,
    sel_field: 'entity_id', // NOTICE not object_id!
    acl_schema: 'priv',
    acl_table: 'group_memberships_acl'
  });
  expect(result).toMatchSnapshot();
});

it('owned_removed', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'group_id',
    sel_obj: true,
    sel_field: 'id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    obj_schema: 'obj_schema',
    obj_table: 'owned_objects',
    obj_field: 'owner_id'
  });
  expect(result).toMatchSnapshot();
});

it('owned_records v2', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it("insert member into organization's group", async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'entity_id',
    sel_obj: true,
    sel_field: 'entity_id',
    acl_schema: 'priv',
    acl_table: 'memberships',
    acl_join_field: 'actor_id',
    obj_schema: 'priv',
    obj_table: 'group_memberships',
    obj_field: 'actor_id',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

// if you aren't a member of a group, but are an owner of the org?
it("insert member into organization's group", async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'entity_id',
    sel_obj: true,
    sel_field: 'entity_id',
    acl_schema: 'priv',
    acl_table: 'memberships',
    acl_join_field: 'actor_id',
    obj_schema: 'priv',
    obj_table: 'group_memberships',
    obj_field: 'actor_id',
    is_admin: true,
    is_owner: true
  });
  expect(result).toMatchSnapshot();
});
