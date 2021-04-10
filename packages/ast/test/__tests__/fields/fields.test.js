import { getConnections } from '../../utils';

let db, teardown;

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
    // noop
  }
});

it('owned_field_func', async () => {
  const [{ owned_field_func_body: result }] = await db.any(
    `select ast_helpers.owned_field_func_body(
        v_role_key := 'sender_id',
        v_func_schema := 'ctx',
        v_func := 'user_id'
    );`
  );
  expect(result).toMatchSnapshot();
});
