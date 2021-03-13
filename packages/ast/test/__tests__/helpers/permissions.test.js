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

it('alter_perm_table_bitlen', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.alter_perm_table_bitlen(
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',
    v_field_name := 'v_field_name',
    v_bitlen := 123
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('alter_perm_table_bitlen_default', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.alter_perm_table_bitlen_default(
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',
    v_field_name := 'v_field_name',
    v_bitlen := 123
  )
);
  `);
  expect(result).toMatchSnapshot();
});
