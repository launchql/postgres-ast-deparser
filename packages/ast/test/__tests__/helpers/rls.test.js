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
  ast_helpers.create_trigger(
    v_trigger_name := 'v_trigger_name',
    
    v_schema_name := 'v_schema_name',
    v_table_name := 'v_table_name',

    v_trigger_fn_schema := 'v_trigger_fn_schema',
    v_trigger_fn_name := 'v_trigger_fn_name',

    v_whenClause := ast_helpers.neq(
      v_lexpr := ast_helpers.col('new', 'type'),
      v_rexpr := ast.a_const( v_val := ast.integer(0) )
    ),
    v_params := NULL,
    v_timing := 2,
    v_events := 4
  )
);
  `);
  expect(result).toMatchSnapshot();
});
