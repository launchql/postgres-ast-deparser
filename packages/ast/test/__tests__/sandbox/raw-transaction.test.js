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

it('raw_transaction', async () => {
  const [{ deparse: result }] = await db.any(
    `
    SELECT array_to_string(
      deparser.expressions_array(ast_helpers.raw_transaction(
        v_stmts := to_jsonb(ARRAY[
          ast.raw_stmt(
            v_stmt := ast.select_stmt(
              v_op := 'SETOP_NONE',
              v_targetList := to_jsonb(ARRAY[
                ast.res_target(v_val := ast.a_const(v_val := ast.integer(1)))
              ])
            ),
            v_stmt_len := 1
          )
        ]),
        v_isolation_level := 'REPEATABLE READ',
        v_deferrable := true
      )), ' '
    ) as deparse;
    `, []
  );

  expect(result).toMatchSnapshot();
});