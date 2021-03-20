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

it('policy deparse', async () => {
  const result = await db.any(`
SELECT deparser.deparse(ast_helpers.alter_policy(
  v_policy_name := 'mypolicy',
  v_schema_name := 'schemanamed',
  v_table_name := 'mytable',
  v_roles := '{authenticated}'::text[],
  v_qual := ast.bool_expr('OR_EXPR', to_jsonb(ARRAY[
    ast.a_expr(v_kind := 'AEXPR_OP',
      v_lexpr := ast.column_ref(
        v_fields := to_jsonb(ARRAY[ ast.string('responder_id') ])
      ),
      v_name := to_jsonb(ARRAY[ast.string('=')]),
      v_rexpr := ast.func_call(
        v_funcname := to_jsonb(ARRAY[ ast.string('dbe'), ast.string('get_uid') ]),
        v_args := to_jsonb(ARRAY[ ast.string('c'), ast.string('b') ])
      )  
    ),
    ast.a_expr(v_kind := 'AEXPR_OP',
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
  v_with_check := NULL
))`);
  expect(result).toMatchSnapshot();
});
