import { getConnections } from '../../utils';
import { inserts } from './__fixtures__/inserts';
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

it('func_call', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.func_call( 'dan' ));
  `);
  expect(result).toMatchSnapshot();
});

it('a_expr', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.a_expr(0, ast.string('a'), '=', ast.string('b')) );
  `);
  expect(result).toMatchSnapshot();
});

it('type_name', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ) );
  `);
  expect(result).toMatchSnapshot();
});

it('type_cast', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.type_cast(ast.a_const(ast.null()), ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true )) );
  `);
  expect(result).toMatchSnapshot();
});

it('raw_stmt', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.raw_stmt(
    ast.type_cast(ast.a_const(ast.null()), ast.type_name( to_jsonb(ARRAY[ast.string('text')]), true ))
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('rule_stmt', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.rule_stmt(
    'my-rule',
    3,
    ast.string('<relation placeholder>'),
    ast.string('<whereClause placeholder>'),
    to_jsonb(ARRAY[ ast.string('<actions placeholder>') ])
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_expr', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_expr(
      0,
      ast.string('<lexpr placeholder>'),
      '=',
      ast.string('<rexpr placeholder>')
    )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_expr 0-4', async () => {
  for (let i = 0; i < 5; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.a_expr(
      $1,
      ast.string('<lexpr placeholder>'),
      '=',
      ast.string('<rexpr placeholder>')
    )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('a_expr 0-4 name', async () => {
  for (let i = 0; i < 5; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.a_expr(
      $1,
      ast.string('<lexpr placeholder>'),
      to_jsonb(ARRAY[ast.string('<name1 placeholder>'),ast.string('<name2 placeholder>')]),
      ast.string('<rexpr placeholder>')
    )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('a_expr 5 ', async () => {
  for (let i = 5; i < 6; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.a_expr(
      $1,
      ast.string('<lexpr placeholder>'),
      '=',
      to_jsonb(ARRAY[ast.string('<rexpr placeholder>')])
    )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('a_expr 6-7 ', async () => {
  for (let i = 6; i < 8; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.a_expr(
      $1,
      ast.string('<lexpr placeholder>'),
      '=',
      to_jsonb(ARRAY[ast.string('<rexpr placeholder>')])
    )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('a_expr 8-9', async () => {
  for (let i = 8; i < 10; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.a_expr(
      $1,
      ast.string('<lexpr placeholder>'),
      '=',
      ast.string('<rexpr placeholder>')
    )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('a_expr 10', async () => {
  for (let i = 10; i < 11; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.a_expr(
      $1,
      ast.string('<lexpr placeholder>'),
      '=',
      ast.func_call('func', to_jsonb(ARRAY[
        ast.string('arg1'),
        ast.string('arg2')
      ]))
    )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('a_expr 11-12', async () => {
  for (let i = 11; i < 13; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.a_expr(
      $1,
      ast.string('<lexpr placeholder>'),
      '=',
      to_jsonb(ARRAY[
        ast.string('arg1'),
        ast.string('arg2')
      ])
    )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('alias', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.alias(
    'myrule',
    to_jsonb(ARRAY[ ast.string('namesplaceholder') ])
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('alias', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.alias(
    'myrule'
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_array_expr', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_array_expr(
    to_jsonb(ARRAY[ 
      ast.string('namesplaceholder1'),
      ast.string('namesplaceholder2')
    ])
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_const', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_const(
    'aconst'
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_const str', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_const(
    ast.string('astring')
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_const int', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_const(
    ast.integer(2)
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_indices', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_indices(
    ast.integer(2)
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_indices', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_indices(
    ast.integer(2),
    ast.integer(2)
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_indirection', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_indirection(
    ast.integer(2),
    to_jsonb(ARRAY[ 
      ast.string('namesplaceholder1'),
      ast.string('namesplaceholder2')
    ])
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('a_star', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.a_star( )
);
  `);
  expect(result).toMatchSnapshot();
});

it('bit_string', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.bit_string(
    'mystring'
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('bool_expr', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.bool_expr(
    0,
    to_jsonb(ARRAY[ 
      ast.string('namesplaceholder1'),
      ast.string('namesplaceholder2')
    ])
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('bool_expr', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.bool_expr(
    1,
    to_jsonb(ARRAY[ 
      ast.string('namesplaceholder1'),
      ast.string('namesplaceholder2')
    ])
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('bool_expr', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.bool_expr(
    2,
    to_jsonb(ARRAY[ 
      ast.string('namesplaceholder1'),
      ast.string('namesplaceholder2')
    ])
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('boolean_test', async () => {
  for (let i = 0; i < 6; i++) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.boolean_test(
    $1,
    ast.string('<booltest placeholder>')
  )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('case_expr', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.case_expr(
    ast.string('<arg placeholder>'),
    to_jsonb(ARRAY[ 
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ]),
    ast.string('<defresult placeholder>')
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('case_expr', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.case_expr(
    ast.string('<arg placeholder>'),
    NULL,
    ast.string('<defresult placeholder>')
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('coalesce_expr', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.coalesce_expr(
    to_jsonb(ARRAY[ 
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ])
    )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('collate_clause', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.collate_clause(
    ast.string('<arg1>'),
    to_jsonb(ARRAY[ 
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ])
    )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('composite_type_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.composite_type_stmt(
    ast.string('<arg1>'),
    to_jsonb(ARRAY[ 
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ])
    )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('rename_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.rename_stmt(
    6,
    6,
    ast.string('<arg1>'),
    'subname',
    'newname'
    )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('column_def', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.column_def(
    'mycol',
    ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ),
    to_jsonb(ARRAY[ 
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ]),
    ast.collate_clause(
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ),
    ast.string('<arg3>')
   )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('column_def', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.column_def(
    'mycol',
    ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ),
    to_jsonb(ARRAY[ 
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ]),
    NULL,
    NULL
   )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('column_def', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.column_def(
    'my-col',
    ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ),
    NULL,
    NULL,
    NULL
   )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('sql_value_function', async () => {
  for (const i of [0, 3, 10, 12]) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.sql_value_function(
    $1
   )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('column_ref', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.column_ref(
    to_jsonb(ARRAY[ 
      ast.string('<arg1>'),
      ast.string('<arg2>')
    ])
   )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('column_ref', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.column_ref(
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ])
   )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('comment_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.comment_stmt(
    6,
    ast.string('<object>'),
    'my comment',
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ])
   )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('common_table_expr', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.common_table_expr(
    'ctename',
    ast.string('<ctequery>'),
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ])
   )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('def_elem', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.def_elem(
    'thing',
    ast.string('<arg>'),
    0
    )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('def_elem', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.def_elem(
    'transaction_isolation',
    ast.a_const(ast.string('mylevel')),
    0
    )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('do_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.do_stmt(
    'RUN MY CODEZ'
    )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('float', async () => {
  for (const i of [0.1234, 3234.234235234, 3.145, 234.2342432]) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  ast.float(
    $1::float
  )
);
  `,
      [i]
    );
    expect(result).toMatchSnapshot();
  }
});

it('func_call', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.func_call(
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ]),
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ]),
    true,
    true
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('func_call', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.func_call(
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ]),
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ]),
    true,
    true,
    true,
    true,
    ast.string('arg2'),
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ]),
    ast.string('arg2')
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('func_call', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.func_call(
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ]),
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ]),
    false,
    false,
    false,
    false,
    ast.string('arg2'),
    to_jsonb(ARRAY[ 
      ast.string('arg1'),
      ast.string('arg2')
    ]),
    ast.string('arg2')
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('grouping_func', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.grouping_func(
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ])
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('grouping_set', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.grouping_set(
    0
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('grouping_set', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.grouping_set(
    2,
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ])
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('grouping_set', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.grouping_set(
    3,
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ])
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('grouping_set', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.grouping_set(
    4,
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ])
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('index_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.index_stmt(
    ast.string('<relation>')
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('index_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.index_stmt(
    ast.string('<relation>'),
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ])
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('index_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.index_stmt(
    ast.string('<relation>'),
    to_jsonb(ARRAY[ 
      ast.string('name1'),
      ast.string('name2')
    ])::jsonb,
    NULL::jsonb,
    true,
    'idxname'::text,
    true
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('index_elem', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.index_elem(
    'indexname',
    ast.string('<relation>')
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('insert_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.insert_stmt(
    ast.string('<relation>')
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('insert_stmt', async () => {
  const [{ deparse: result }] = await db.any(
    `
select deparser.deparse(
  ast.insert_stmt(
    ast.string('<relation>'),
    to_jsonb(ARRAY[ 
      ast.string('id'),
      ast.string('name')
    ])::jsonb
  )
);
  `
  );
  expect(result).toMatchSnapshot();
});

it('insert_stmt', async () => {
  for (const insert of inserts) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  $1::jsonb
);
  `,
      [insert]
    );
    expect(result).toMatchSnapshot();
  }
});
