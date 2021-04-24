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

it('test', async () => {
  const [{ denormalized_fields_trigger_body: result }] = await db.any(
    `
        SELECT ast_helpers.denormalized_fields_trigger_body (
            v_schema_name := 'v_schema_name',
            v_table_name := 'v_table_name',
            v_parent_key := 'v_parent_key',
            v_ref_key := 'v_ref_key',
            
            v_sel_fields := '{a,b,c}',
            v_into_fields := '{d,e,f}'
        )`,
    []
  );

  expect(result).toMatchSnapshot();
});
