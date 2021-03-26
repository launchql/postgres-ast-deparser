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
    // noop
  }
});

it('alter_table_add_constraint', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast_helpers.alter_table_add_check_constraint(
        v_schema_name := 'schema_name',
        v_table_name := 'table_name',
        v_constraint_name := 'constraint_name',
        v_constraint_expr := ast_helpers.matches(
            v_lexpr := ast.column_ref(
                v_fields := to_jsonb(ARRAY[
                    ast.string('email')
                ])
            ),
            v_regexp := '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
        )
    )
);`);
  expect(result).toMatchSnapshot();
});

it('alter_table_add_constraint', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast_helpers.alter_table_add_check_constraint(
        v_schema_name := 'schema_name',
        v_table_name := 'table_name',
        v_constraint_name := 'constraint_name',
        v_constraint_expr := ast_helpers.and(
            ast_helpers.matches(
                v_lexpr := ast.column_ref(
                    v_fields := to_jsonb(ARRAY[
                        ast.string('email')
                    ])
                ),
                v_regexp := '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
            ),
            ast_helpers.matches(
                v_lexpr := ast.column_ref(
                    v_fields := to_jsonb(ARRAY[
                        ast.string('email')
                    ])
                ),
                v_regexp := '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
            )
        )
    )
);`);
  expect(result).toMatchSnapshot();
});

it('modify_constraint', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(

    
    ast.alter_table_cmd(
      v_subtype := 'AT_DropConstraint',
      v_name := 'v_constraint_name',
      v_behavior := 'DROP_RESTRICT',
      v_missing_ok := TRUE -- DO WE WANT THIS BY DEFAULT?
    )

    
);`);
  expect(result).toMatchSnapshot();
});
