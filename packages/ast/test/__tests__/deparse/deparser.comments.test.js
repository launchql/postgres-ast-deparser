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

// WE NEED TO COMMENT OUT or whitelist m2m relations...

it('OBJECT_FUNCTION comment', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_FUNCTION',
        v_object := ast.object_with_args(
            v_objname := to_jsonb(ARRAY[
                ast.string('my_function')
            ]),
            v_objargs := to_jsonb(ARRAY[
                ast.type_name(
                    v_names := to_jsonb(ARRAY[ 
                        ast.string('arg_type_1')
                    ])
                ),
                ast.type_name(
                    v_names := to_jsonb(ARRAY[ 
                        ast.string('arg_type_2')
                    ])
                )
            ])
        ),
        v_comment := 'asdf'
    )
);`);
  expect(result).toMatchSnapshot();
});

it('helpers function', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
      ast_helpers.set_comment_on_function(
          v_schema_name := 'schema-name',
          v_function_name := 'function-name',
          v_comment := 'hithere'
      )
  );`);
  expect(result).toMatchSnapshot();
});

it('smart_comments helpers function', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
      ast_helpers.set_comment_on_function(
          v_schema_name := 'schema-name',
          v_function_name := 'function-name',
          v_tags := $1::jsonb,
          v_description := $2
      )
  );`,
    [{ b: 1, c: [0, 1, 2, 3] }, 'my description']
  );
  expect(result).toMatchSnapshot();
});
it('helpers table', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_TABLE',
          v_comment := 'hithere',
          variadic v_name := ARRAY[
              'schema-name',
              'table-name'
          ]
      )
  );`);
  expect(result).toMatchSnapshot();
});

it('smart_comments helpers table', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_TABLE',
          v_tags := $1::jsonb,
          v_description := $2,
          variadic v_name := ARRAY[
              'schema_name',
              'table_name'
          ]
      )
  );`,
    [
      {
        here: 'wego'
      },
      'my description'
    ]
  );
  expect(result).toMatchSnapshot();
});

it('smart_comments helpers table', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_TABLE',
          v_tags := $1::jsonb,
          v_description := $2,
          variadic v_name := ARRAY[
              'schema_name',
              'table_name'
          ]
      )
  );`,
    [
      {
        here: 'wego'
      },
      null
    ]
  );
  expect(result).toMatchSnapshot();
});

it('smart_comments helpers table', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_TABLE',
          v_tags := $1::jsonb,
          v_description := $2,
          variadic v_name := ARRAY[
              'schema_name',
              'table_name'
          ]
      )
  );`,
    [null, 'my descript']
  );
  expect(result).toMatchSnapshot();
});

it('smart_comments helpers table', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_TABLE',
          v_tags := $1::jsonb,
          v_description := $2,
          variadic v_name := ARRAY[
              'schema_name',
              'table_name'
          ]
      )
  );`,
    [null, null]
  );
  expect(result).toMatchSnapshot();
});

it('smart_comments helpers column', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_COLUMN',
          v_tags := $1::jsonb,
          v_description := $2,
          variadic v_name := ARRAY[
              'schema_name',
              'table_name',
              'column_name'
          ]
      )
  );`,
    [
      {
        here: 'wego'
      },
      'my description'
    ]
  );
  expect(result).toMatchSnapshot();
});

it('helpers table constraint', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_TABCONSTRAINT',
          v_comment := 'hithere',
          variadic v_name := ARRAY[
              'schema-name',
              'table_name',
              'my_constraint'
          ]
      )
  );`);
  expect(result).toMatchSnapshot();
});

it('helpers table constraint', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast_helpers.set_comment(
          v_objtype := 'OBJECT_TABCONSTRAINT',
          v_comment := 'hithere',
          variadic v_name := ARRAY[
              'table_name',
              'my_constraint'
          ]
      )
  );`);
  expect(result).toMatchSnapshot();
});

it('OBJECT_COLUMN comment', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_COLUMN',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_table'),
            ast.string('my_column')
        ]),
        v_comment := 'asdf'
    )
);`);
  expect(result).toMatchSnapshot();
});

it('OBJECT_TABLE comment', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_TABLE',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_table')
        ]),
        v_comment := 'asdf'
    )
);`);
  expect(result).toMatchSnapshot();
});

it('OBJECT_VIEW comment', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_VIEW',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_view')
        ]),
        v_comment := 'asdf'
    )
);`);
  expect(result).toMatchSnapshot();
});

it('OBJECT_MATVIEW comment', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_MATVIEW',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_view')
        ]),
        v_comment := 'asdf'
    )
);`);
  expect(result).toMatchSnapshot();
});

it('OBJECT_TYPE comment', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_TYPE',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_type')
        ]),
        v_comment := 'asdf'
    )
);`);
  expect(result).toMatchSnapshot();
});

it('OBJECT_TABCONSTRAINT comment', async () => {
  const [{ expression: result }] = await db.any(`select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_TABCONSTRAINT',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_table'),
            ast.string('my_constraint')
        ]),
        v_comment := 'asdf'
    )
);`);
  expect(result).toMatchSnapshot();
});
