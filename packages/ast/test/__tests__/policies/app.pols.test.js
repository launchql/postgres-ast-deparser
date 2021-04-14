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

it('1 core database', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'mem_priv',
    acl_table: 'memberships_acl'
  });
  expect(result).toMatchSnapshot();
});

it('1 core table', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'database_id',
    sel_obj: true,
    sel_field: 'id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    acl_join_field: 'entity_id',
    obj_schema: 'collections_public',
    obj_table: 'database',
    obj_field: 'owner_id'
  });
  expect(result).toMatchSnapshot();
});

//

it('groups READ', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'priv',
    acl_table: 'group_memberships_acl'
  });
  expect(result).toMatchSnapshot();
});

it('groups WRITE', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'priv',
    acl_table: 'group_memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('group_memberships WRITE', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'entity_id',
    sel_obj: true,
    sel_field: 'entity_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    acl_join_field: 'actor_id',
    obj_schema: 'priv',
    obj_table: 'group_memberships_acl',
    obj_field: 'actor_id',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('group_memberships READ', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'entity_id',
    acl_schema: 'priv',
    acl_table: 'group_memberships_acl'
  });
  expect(result).toMatchSnapshot();
});

it('actions READ', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl'
  });
  expect(result).toMatchSnapshot();
});

it('actions WRITE', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('action_items WRITE', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('action_items INSERT', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'action_id',
    sel_obj: true,
    sel_field: 'id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    acl_join_field: 'entity_id',
    obj_schema: 'public',
    obj_table: 'actions',
    obj_field: 'owner_id',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

/*
this one is a bit interesting, since it's cross referencing 
two different ACL tables, leveraging actor_id as the actual organization

essentially this reads as:
find entities where the current user is an admin (this would include their own account)
*/

it('app_memberships READ', async () => {
  const result = await getPolicyResult('acl_field_join', {
    entity_field: 'entity_id',
    sel_obj: true,
    sel_field: 'actor_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    acl_join_field: 'entity_id',
    obj_schema: 'priv',
    obj_table: 'app_memberships_acl',
    obj_field: 'actor_id',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('app_memberships ADMIN READ/WRITE', async () => {
  const result = await getPolicyResult('acl_exists', {
    acl_schema: 'priv',
    acl_table: 'app_memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('emails READ', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl'
  });
  expect(result).toMatchSnapshot();
});

it('emails WRITE', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'owner_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('memberships READ', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'entity_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl'
  });
  expect(result).toMatchSnapshot();
});

it('memberships WRITE', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'entity_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('org_profiles WRITE', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'organization_id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});

it('users WRITE', async () => {
  const result = await getPolicyResult('acl_field', {
    entity_field: 'id',
    acl_schema: 'priv',
    acl_table: 'memberships_acl',
    is_admin: true
  });
  expect(result).toMatchSnapshot();
});
