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

it('create_trigger deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast_helpers.update_table_permission_bitlen(
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',
    v_field_name := 'v_field_name',
    v_bitlen := 123
  )
);
  `);
  expect(result).toMatchSnapshot();
});
