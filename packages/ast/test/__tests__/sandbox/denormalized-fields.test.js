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
            v_ref_field := 'v_ref_field',
            v_table_field := 'v_table_field',
            
            v_ref_fields := '{a,b,c}',
            v_set_fields := '{d,e,f}'
        )`,
    []
  );

  expect(result).toMatchSnapshot();
});
