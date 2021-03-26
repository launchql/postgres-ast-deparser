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
  } catch (e) {
    console.log(e);
  }
});

it('rls_membership_type_select', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.rls_membership_type_select(
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',
    v_membership_type_name := 'Organization'
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('rls_policy_permission_mask_select', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.rls_policy_permission_mask_select(
    v_schema_name := 'v_schema_name',
    v_function_name := 'v_function_name',
    v_permission := 'Can I do this?'
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('rls_policy_permission_mask_select', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.rls_policy_permission_mask_select(
    v_schema_name := 'v_schema_name',
    v_function_name := 'v_function_name',
    v_permissions := ARRAY['Can I do this?', 'Can I also do this']
  )
);
  `);
  expect(result).toMatchSnapshot();
});
