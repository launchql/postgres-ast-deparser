import { getConnections } from '../../utils';
import {
  policies,
  current_groups_ast,
  current_groups_ast2,
  current_user_ast
} from './__fixtures__/policies';
import policyStmt from './__fixtures__/policy';

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

it('deparse', async () => {
  const [{ deparse: result }] = await db.any(`
  select deparser.deparse( '${JSON.stringify(policies[0])}'::jsonb );
  `);
  expect(result).toMatchSnapshot();
});

it('policy deparse', async () => {
  const result = await db.any(`
SELECT deparser.deparse(ast_helpers.create_policy(
  v_policy_name := 'mypolicy',
  v_schema_name := 'schemanamed',
  v_table_name := 'mytable',
  v_roles := '{authenticated}'::text[],
  v_qual := ast.bool_expr(1, to_jsonb(ARRAY[
    ast.a_expr(v_kind := 0,
      v_lexpr := ast.column_ref(
        v_fields := to_jsonb(ARRAY[ ast.string('responder_id') ])
      ),
      v_name := to_jsonb(ARRAY[ast.string('=')]),
      v_rexpr := ast.func_call(
        v_funcname := to_jsonb(ARRAY[ ast.string('dbe'), ast.string('get_uid') ]),
        v_args := to_jsonb(ARRAY[ ast.string('c'), ast.string('b') ])
      )  
    ),
    ast.a_expr(v_kind := 0,
      v_lexpr := ast.column_ref(
        v_fields := to_jsonb(ARRAY[ ast.string('requester_id') ])
      ),
      v_name := to_jsonb(ARRAY[ast.string('=')]),
      v_rexpr := ast.func_call(
        v_funcname := to_jsonb(ARRAY[ ast.string('dbe'), ast.string('get_other_uid') ]),
        v_args := to_jsonb(ARRAY[ ast.string('c'), ast.string('b') ])
      )  
    )
  ])),
  v_cmd_name := 'INSERT',
  v_with_check := NULL,
  v_permissive := true
))`);
  expect(result).toMatchSnapshot();
});

const getInsertPolicyResult = async (name, vars) => {
  const [{ deparse }] = await db.any(
    `
SELECT deparser.deparse(
  ast_helpers.create_policy(
    v_policy_name := 'v_policy_name',
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',
    v_roles := ARRAY['authenticated'],
    v_cmd_name := 'INSERT',
    v_permissive := TRUE,
    v_with_check := ast_helpers.create_policy_template(
        policy_template_name := $1::text,
        policy_template_vars := $2::jsonb
    )
  )
)`,
    [name, JSON.stringify(vars)]
  );
  return deparse;
};

const getUpdatePolicyResult = async (name, vars) => {
  const [{ deparse }] = await db.any(
    `
SELECT deparser.deparse(
  ast_helpers.create_policy(
    v_policy_name := 'v_policy_name',
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',
    v_roles := ARRAY['authenticated'],
    v_cmd_name := 'UPDATE',
    v_permissive := TRUE,
    v_qual := ast_helpers.create_policy_template(
        policy_template_name := $1::text,
        policy_template_vars := $2::jsonb
    )
  )
)`,
    [name, JSON.stringify(vars)]
  );
  return deparse;
};

const getPolicyResult = async (name, vars) => {
  const [{ deparse }] = await db.any(
    `
SELECT deparser.deparse(
  ast_helpers.create_policy_template(
  policy_template_name := $1::text,
  policy_template_vars := $2::jsonb
  ))`,
    [name, JSON.stringify(vars)]
  );

  return {
    insert: await getInsertPolicyResult(name, vars),
    update: await getUpdatePolicyResult(name, vars),
    policy: deparse
  };
};

it('own_records', async () => {
  const result = await getPolicyResult('own_records', {
    role_key: 'role_key',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn'
  });
  expect(result).toMatchSnapshot();
});

it('owned_records', async () => {
  const result = await getPolicyResult('owned_records', {
    role_key: 'role_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn'
  });
  expect(result).toMatchSnapshot();
});

it('owned_records w bits', async () => {
  const result = await getPolicyResult('owned_records', {
    role_key: 'role_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn',
    current_groups_ast
  });
  expect(result).toMatchSnapshot();
});

it('owned_records w bits', async () => {
  const result = await getPolicyResult('owned_records', {
    role_key: 'role_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn',
    current_groups_ast: current_groups_ast2
  });
  expect(result).toMatchSnapshot();
});

it('own_records defaults', async () => {
  const result = await getPolicyResult('own_records', {
    role_key: 'role_key'
  });
  expect(result).toMatchSnapshot();
});

it('owned_records defaults', async () => {
  const result = await getPolicyResult('owned_records', {
    role_key: 'role_key'
  });
  expect(result).toMatchSnapshot();
});

it('multi_owners', async () => {
  const result = await getPolicyResult('multi_owners', {
    role_keys: ['requester_id', 'responder_id', 'verifier_id'],
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn'
  });
  expect(result).toMatchSnapshot();
});

it('permission_name', async () => {
  const result = await getPolicyResult('permission_name', {
    permission_role_key: 'permission_role_key',
    permission_schema: 'permission_schema',
    permission_table: 'permission_table',
    permission_name_key: 'permission_name_key',
    this_value: 'this_value',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn'
  });
  expect(result).toMatchSnapshot();
});

it('permission_name w bits', async () => {
  const result = await getPolicyResult('permission_name', {
    permission_role_key: 'permission_role_key',
    permission_schema: 'permission_schema',
    permission_table: 'permission_table',
    permission_name_key: 'permission_name_key',
    this_value: 'this_value',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    current_groups_ast
  });
  expect(result).toMatchSnapshot();
});

it('policy w permission_name', async () => {
  const result = await getInsertPolicyResult('permission_name', {
    permission_role_key: 'permission_role_key',
    permission_schema: 'permission_schema',
    permission_table: 'permission_table',
    permission_name_key: 'permission_name_key',
    this_value: 'this_value',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn'
  });
  expect(result).toMatchSnapshot();
});

it('owned_object_records', async () => {
  const result = await getPolicyResult('owned_object_records', {
    owned_table_key: 'owned_table_key',
    owned_schema: 'owned_schema',
    owned_table: 'owned_table',
    owned_table_ref_key: 'owned_table_ref_key',
    this_object_key: 'this_object_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn'
  });
  expect(result).toMatchSnapshot();
});

it('owned_object_records bits', async () => {
  const result = await getPolicyResult('owned_object_records', {
    owned_table_key: 'owned_table_key',
    owned_schema: 'owned_schema',
    owned_table: 'owned_table',
    owned_table_ref_key: 'owned_table_ref_key',
    this_object_key: 'this_object_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn',
    current_groups_ast
  });
  expect(result).toMatchSnapshot();
});

it('owned_object_records_group_array', async () => {
  const result = await getPolicyResult('owned_object_records_group_array', {
    owned_table_key: 'owned_table_key',
    owned_schema: 'owned_schema',
    owned_table: 'owned_table',
    owned_table_ref_key: 'owned_table_ref_key',
    this_object_key: 'this_object_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn'
  });
  expect(result).toMatchSnapshot();
});

it('owned_object_records_group_array bits', async () => {
  const result = await getPolicyResult('owned_object_records_group_array', {
    owned_table_key: 'owned_table_key',
    owned_schema: 'owned_schema',
    owned_table: 'owned_table',
    owned_table_ref_key: 'owned_table_ref_key',
    this_object_key: 'this_object_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn',
    current_groups_ast,
    current_user_ast
  });
  expect(result).toMatchSnapshot();
});

it('child_of_owned_object_records', async () => {
  const result = await getPolicyResult('child_of_owned_object_records', {
    owned_table_key: 'owned_table_key',
    object_schema: 'object_schema',
    object_table: 'object_table',
    owned_schema: 'owned_schema',
    owned_table: 'owned_table',
    owned_table_ref_key: 'owned_table_ref_key',
    object_table_owned_key: 'object_table_owned_key',
    object_table_ref_key: 'object_table_ref_key',
    this_object_key: 'this_object_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn'
  });
  expect(result).toMatchSnapshot();
});

it('child_of_owned_object_records bits', async () => {
  const result = await getPolicyResult('child_of_owned_object_records', {
    owned_table_key: 'owned_table_key',
    object_schema: 'object_schema',
    object_table: 'object_table',
    owned_schema: 'owned_schema',
    owned_table: 'owned_table',
    owned_table_ref_key: 'owned_table_ref_key',
    object_table_owned_key: 'object_table_owned_key',
    object_table_ref_key: 'object_table_ref_key',
    this_object_key: 'this_object_key',
    rls_groups_schema: 'rls_schema',
    rls_groups: 'group_fn',
    rls_role_schema: 'rls_schema',
    rls_role: 'role_fn',
    current_groups_ast
  });
  expect(result).toMatchSnapshot();
});

it('child_of_owned_object_records_with_ownership', async () => {
  const result = await getPolicyResult(
    'child_of_owned_object_records_with_ownership',
    {
      owned_table_key: 'owned_table_key',
      object_schema: 'object_schema',
      object_table: 'object_table',
      owned_schema: 'owned_schema',
      owned_table: 'owned_table',
      owned_table_ref_key: 'owned_table_ref_key',
      object_table_owned_key: 'object_table_owned_key',
      object_table_ref_key: 'object_table_ref_key',
      this_object_key: 'this_object_key',

      // only one extra?
      this_owned_key: 'this_owned_key',
      rls_groups_schema: 'rls_schema',
      rls_groups: 'group_fn',
      rls_role_schema: 'rls_schema',
      rls_role: 'role_fn'
    }
  );
  expect(result).toMatchSnapshot();
});

it('child_of_owned_object_records_with_ownership bits', async () => {
  const result = await getPolicyResult(
    'child_of_owned_object_records_with_ownership',
    {
      owned_table_key: 'owned_table_key',
      object_schema: 'object_schema',
      object_table: 'object_table',
      owned_schema: 'owned_schema',
      owned_table: 'owned_table',
      owned_table_ref_key: 'owned_table_ref_key',
      object_table_owned_key: 'object_table_owned_key',
      object_table_ref_key: 'object_table_ref_key',
      this_object_key: 'this_object_key',

      // only one extra?
      this_owned_key: 'this_owned_key',
      rls_groups_schema: 'rls_schema',
      rls_groups: 'group_fn',
      rls_role_schema: 'rls_schema',
      rls_role: 'role_fn',
      current_groups_ast
    }
  );
  expect(result).toMatchSnapshot();
});

it('child_of_owned_object_records_group_array', async () => {
  const result = await getPolicyResult(
    'child_of_owned_object_records_group_array',
    {
      owned_table_key: 'owned_table_key',
      object_schema: 'messages_schema',
      object_table: 'messages_table',
      owned_schema: 'groups_schema',
      owned_table: 'groups_table',

      owned_table_ref_key: 'id', // groups_pkey
      object_table_owned_key: 'group_id',

      object_table_ref_key: 'id', // message_pkey
      this_object_key: 'id',
      rls_groups_schema: 'rls_schema',
      rls_groups: 'group_fn',
      rls_role_schema: 'rls_schema',
      rls_role: 'role_fn'
    }
  );
  expect(result).toMatchSnapshot();
});

it('child_of_owned_object_records_group_array bits', async () => {
  const result = await getPolicyResult(
    'child_of_owned_object_records_group_array',
    {
      owned_table_key: 'owned_table_key',
      object_schema: 'messages_schema',
      object_table: 'messages_table',
      owned_schema: 'groups_schema',
      owned_table: 'groups_table',

      owned_table_ref_key: 'id', // groups_pkey
      object_table_owned_key: 'group_id',

      object_table_ref_key: 'id', // message_pkey
      this_object_key: 'id',
      rls_groups_schema: 'rls_schema',
      rls_groups: 'group_fn',
      rls_role_schema: 'rls_schema',
      rls_role: 'role_fn',
      current_groups_ast
    }
  );
  expect(result).toMatchSnapshot();
});

it('acl', async () => {
  const result = await getPolicyResult('acl', {
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it('acl mask', async () => {
  const result = await getPolicyResult('acl', {
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    mask: '1010101111'
  });
  expect(result).toMatchSnapshot();
});

it('entity_acl', async () => {
  const result = await getPolicyResult('entity_acl', {
    entity_field: 'entity_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it('entity_acl include user', async () => {
  const result = await getPolicyResult('entity_acl', {
    include_current_user_id: true,
    entity_field: 'entity_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table'
  });
  expect(result).toMatchSnapshot();
});

it('entity_acl_mask', async () => {
  const result = await getPolicyResult('entity_acl', {
    entity_field: 'entity_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    mask: '1010010100101010111111'
  });
  expect(result).toMatchSnapshot();
});

it('entity_acl_mask include user', async () => {
  const result = await getPolicyResult('entity_acl', {
    include_current_user_id: true,
    entity_field: 'entity_id',
    acl_schema: 'acl_schema',
    acl_table: 'acl_table',
    mask: '1010010100101010111111'
  });
  expect(result).toMatchSnapshot();
});

it('open', async () => {
  const result = await getPolicyResult('open', {});
  expect(result).toMatchSnapshot();
});

it('policyStmt', async () => {
  const result = await db.any(
    `
SELECT deparser.deparse(
    $1::jsonb
  )`,
    [JSON.stringify(policyStmt)]
  );
  expect(result).toMatchSnapshot();
});

it('drop_policy', async () => {
  const result = await db.any(
    `
SELECT deparser.deparse(
  ast_helpers.drop_policy(
    v_policy_name := 'v_policy_name',
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name'
  )
  )`
  );
  expect(result).toMatchSnapshot();
});
