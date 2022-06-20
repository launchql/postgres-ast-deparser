import { getConnections } from '../../utils';
import { inserts } from './__fixtures__/inserts';
import { selects } from './__fixtures__/selects';
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
select deparser.deparse( ast.func_call( 
  v_funcname := to_jsonb(ARRAY[ast.string('dan')])
));
  `);
  expect(result).toMatchSnapshot();
});

it('a_expr', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.a_expr(
  v_kind  := 'AEXPR_OP',
  v_lexpr := ast.string('a'),
  v_name  := to_jsonb(ARRAY[ast.string('=')]),
  v_rexpr := ast.string('b'))
);
  `);
  expect(result).toMatchSnapshot();
});

it('type_name', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.type_name(
   v_names := to_jsonb(ARRAY[ast.string('text')])
));
  `);
  expect(result).toMatchSnapshot();
});

it('type_cast', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( ast.type_cast(
  v_arg := ast.a_const(ast.null()),
  v_typename := ast.type_name( 
    v_names := to_jsonb(ARRAY[ast.string('text')]),
    v_arrayBounds := to_jsonb(ARRAY[ast.integer(-1)])
  )
));`);
  expect(result).toMatchSnapshot();
});

it('raw_stmt', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse(
  ast.raw_stmt(
    ast.type_cast(
      v_arg := ast.a_const(ast.null()),
      v_typename := ast.type_name( 
        v_names := to_jsonb(ARRAY[ast.string('text')]),
        v_arrayBounds := to_jsonb(ARRAY[ast.integer(-1)])
      )
    )
  )
);
  `);
  expect(result).toMatchSnapshot();
});

// it('rule_stmt', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.rule_stmt(
//     'my-rule',
//     3,
//     ast.string('<relation placeholder>'),
//     ast.string('<whereClause placeholder>'),
//     to_jsonb(ARRAY[ ast.string('<actions placeholder>') ])
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_expr', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_expr(
//       0,
//       ast.string('<lexpr placeholder>'),
//       '=',
//       ast.string('<rexpr placeholder>')
//     )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_expr 0-4', async () => {
//   for (let i = 0; i < 5; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.a_expr(
//       $1,
//       ast.string('<lexpr placeholder>'),
//       '=',
//       ast.string('<rexpr placeholder>')
//     )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('a_expr 0-4 name', async () => {
//   for (let i = 0; i < 5; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.a_expr(
//       $1,
//       ast.string('<lexpr placeholder>'),
//       to_jsonb(ARRAY[ast.string('<name1 placeholder>'),ast.string('<name2 placeholder>')]),
//       ast.string('<rexpr placeholder>')
//     )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('a_expr 5 ', async () => {
//   for (let i = 5; i < 6; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.a_expr(
//       $1,
//       ast.string('<lexpr placeholder>'),
//       '=',
//       to_jsonb(ARRAY[ast.string('<rexpr placeholder>')])
//     )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('a_expr 6-7 ', async () => {
//   for (let i = 6; i < 8; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.a_expr(
//       $1,
//       ast.string('<lexpr placeholder>'),
//       '=',
//       to_jsonb(ARRAY[ast.string('<rexpr placeholder>')])
//     )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('a_expr 8-9', async () => {
//   for (let i = 8; i < 10; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.a_expr(
//       $1,
//       ast.string('<lexpr placeholder>'),
//       '=',
//       ast.string('<rexpr placeholder>')
//     )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('a_expr 10', async () => {
//   for (let i = 10; i < 11; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.a_expr(
//       $1,
//       ast.string('<lexpr placeholder>'),
//       '=',
//       ast.func_call('func', to_jsonb(ARRAY[
//         ast.string('arg1'),
//         ast.string('arg2')
//       ]))
//     )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('a_expr 11-12', async () => {
//   for (let i = 11; i < 13; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.a_expr(
//       $1,
//       ast.string('<lexpr placeholder>'),
//       '=',
//       to_jsonb(ARRAY[
//         ast.string('arg1'),
//         ast.string('arg2')
//       ])
//     )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('alias', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.alias(
//     'myrule',
//     to_jsonb(ARRAY[ ast.string('namesplaceholder') ])
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('alias', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.alias(
//     'myrule'
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_array_expr', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_array_expr(
//     to_jsonb(ARRAY[
//       ast.string('namesplaceholder1'),
//       ast.string('namesplaceholder2')
//     ])
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_const', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_const(
//     'aconst'
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_const str', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_const(
//     ast.string('astring')
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_const int', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_const(
//     ast.integer(2)
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_indices', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_indices(
//     ast.integer(2)
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_indices', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_indices(
//     ast.integer(2),
//     ast.integer(2)
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_indirection', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_indirection(
//     ast.integer(2),
//     to_jsonb(ARRAY[
//       ast.string('namesplaceholder1'),
//       ast.string('namesplaceholder2')
//     ])
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('a_star', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.a_star( )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('bit_string', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.bit_string(
//     'mystring'
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('bool_expr', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.bool_expr(
//     0,
//     to_jsonb(ARRAY[
//       ast.string('namesplaceholder1'),
//       ast.string('namesplaceholder2')
//     ])
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('bool_expr', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.bool_expr(
//     1,
//     to_jsonb(ARRAY[
//       ast.string('namesplaceholder1'),
//       ast.string('namesplaceholder2')
//     ])
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('bool_expr', async () => {
//   const [{ deparse: result }] = await db.any(`
// select deparser.deparse(
//   ast.bool_expr(
//     2,
//     to_jsonb(ARRAY[
//       ast.string('namesplaceholder1'),
//       ast.string('namesplaceholder2')
//     ])
//   )
// );
//   `);
//   expect(result).toMatchSnapshot();
// });

// it('boolean_test', async () => {
//   for (let i = 0; i < 6; i++) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.boolean_test(
//     $1,
//     ast.string('<booltest placeholder>')
//   )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('case_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.case_expr(
//     ast.string('<arg placeholder>'),
//     to_jsonb(ARRAY[
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ]),
//     ast.string('<defresult placeholder>')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('case_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.case_expr(
//     ast.string('<arg placeholder>'),
//     NULL,
//     ast.string('<defresult placeholder>')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('coalesce_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.coalesce_expr(
//     to_jsonb(ARRAY[
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ])
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('collate_clause', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.collate_clause(
//     ast.string('<arg1>'),
//     to_jsonb(ARRAY[
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ])
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('composite_type_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.composite_type_stmt(
//     ast.string('<arg1>'),
//     to_jsonb(ARRAY[
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ])
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('rename_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.rename_stmt(
//     6,
//     6,
//     ast.string('<arg1>'),
//     'subname',
//     'newname'
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('column_def', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.column_def(
//     'mycol',
//     ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ),
//     to_jsonb(ARRAY[
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ]),
//     ast.collate_clause(
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ),
//     ast.string('<arg3>')
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('column_def', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.column_def(
//     'mycol',
//     ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ),
//     to_jsonb(ARRAY[
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ]),
//     NULL,
//     NULL
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('column_def', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.column_def(
//     'my-col',
//     ast.type_name( to_jsonb(ARRAY[ast.string('text')]) ),
//     NULL,
//     NULL,
//     NULL
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('sql_value_function', async () => {
//   for (const i of [0, 3, 10, 12]) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.sql_value_function(
//     $1
//    )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('column_ref', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.column_ref(
//     to_jsonb(ARRAY[
//       ast.string('<arg1>'),
//       ast.string('<arg2>')
//     ])
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('column_ref', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.column_ref(
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ])
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('comment_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.comment_stmt(
//     6,
//     ast.string('<object>'),
//     'my comment',
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ])
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('common_table_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.common_table_expr(
//     'ctename',
//     ast.string('<ctequery>'),
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ])
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('def_elem', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.def_elem(
//     'thing',
//     ast.string('<arg>'),
//     0
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('def_elem', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.def_elem(
//     'transaction_isolation',
//     ast.a_const(ast.string('mylevel')),
//     0
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('do_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.do_stmt(
//     'RUN MY CODEZ'
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('float', async () => {
//   for (const i of [0.1234, 3234.234235234, 3.145, 234.2342432]) {
//     const [{ deparse: result }] = await db.any(
//       `
// select deparser.deparse(
//   ast.float(
//     $1::float
//   )
// );
//   `,
//       [i]
//     );
//     expect(result).toMatchSnapshot();
//   }
// });

// it('func_call', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.func_call(
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ]),
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ]),
//     true,
//     true
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('func_call', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.func_call(
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ]),
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ]),
//     true,
//     true,
//     true,
//     true,
//     ast.string('arg2'),
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ]),
//     ast.string('arg2')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('func_call', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.func_call(
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ]),
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ]),
//     false,
//     false,
//     false,
//     false,
//     ast.string('arg2'),
//     to_jsonb(ARRAY[
//       ast.string('arg1'),
//       ast.string('arg2')
//     ]),
//     ast.string('arg2')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('grouping_func', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.grouping_func(
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ])
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('grouping_set', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.grouping_set(
//     0
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('grouping_set', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.grouping_set(
//     2,
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ])
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('grouping_set', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.grouping_set(
//     3,
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ])
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('grouping_set', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.grouping_set(
//     4,
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ])
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('index_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.index_stmt(
//     ast.string('<relation>')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('index_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.index_stmt(
//     ast.string('<relation>'),
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ])
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('index_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.index_stmt(
//     ast.string('<relation>'),
//     to_jsonb(ARRAY[
//       ast.string('name1'),
//       ast.string('name2')
//     ])::jsonb,
//     NULL::jsonb,
//     true,
//     'idxname'::text,
//     true
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('index_elem', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.index_elem(
//     'indexname',
//     ast.string('<relation>')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('insert_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.insert_stmt(
//     ast.string('<relation>')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('insert_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.insert_stmt(
//     ast.string('<relation>'),
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

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

// it('delete_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.delete_stmt(
//     ast.string('<relation>'),
//     ast.string('<whereClause>')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('join_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.join_expr(
//     ast.string('<larg>'),
//     2,
//     ast.string('<rarg>'),
//     true
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('into_clause', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.into_clause(
//     ast.string('<larg>')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('locking_clause', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.locking_clause(
//     0,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('min_max_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.min_max_expr(
//     0,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('min_max_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.min_max_expr(
//     1,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('named_arg_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.named_arg_expr(
//     'mything',
//     ast.string('id')
//   )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('null_test', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.null_test(
//       0
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('param_ref', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.param_ref(
//       0
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('param_ref', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.param_ref(
//       1
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('range_function', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.range_function(
//       true,
//       NULL,
//       true,
//       true,
//       null,
//       null
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('range_subselect', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.range_subselect(
//       true,
//       ast.string('id'),
//       NULL
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('range_var', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.range_var(
//       'schemaname',
//       'relname',
//       TRUE,
//       'p',
//       null
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('row_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.row_expr(
//      2,
//      to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('row_expr', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.row_expr(
//      0,
//      to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('res_target', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.res_target(
//     'hello',
//     ast.string('id')
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('explain_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.explain_stmt(
//     ast.string('id')
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('select_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.select_stmt(
//     0,
//     ast.string('id')
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

it('select_stmt', async () => {
  for (const select of selects) {
    const [{ deparse: result }] = await db.any(
      `
select deparser.deparse(
  $1::jsonb
);
  `,
      [select]
    );
    expect(result).toMatchSnapshot();
  }
});

// it('sort_by', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.sort_by(
//     0,
//     0,
//     ast.string('id'),
//     ast.string('id')
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('drop_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.drop_stmt(
//     0,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     TRUE,
//     1
//    )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('view_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.view_stmt(
//     ast.string('id'),
//     ast.string('name')
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('create_seq_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.create_seq_stmt(
//     ast.string('id'),
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('create_table_as_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.create_table_as_stmt(
//     ast.string('id'),
//     ast.string('id')
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('create_domain_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.create_domain_stmt(
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     ast.string('id'),
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('create_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.create_stmt(
//     ast.string('id'),
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     NULL,
//     NULL
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('constraint', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.constraint(
//     0,
//     NULL
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('access_priv', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.access_priv(
//     'priv',
//     NULL
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('variable_set_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.variable_set_stmt(
//     0,
//     true,
//     'varasdf',
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('grant_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.grant_stmt(
//     0,
//     0,
//     true,
//     true,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     1
//  )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });
// it('grant_role_stmt', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.grant_role_stmt(
//     true,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb,
//     TRUE
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('case_when', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.case_when(
//     ast.string('id'),
//     ast.string('name')
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

// it('with_clause', async () => {
//   const [{ deparse: result }] = await db.any(
//     `
// select deparser.deparse(
//   ast.with_clause(
//     true,
//     to_jsonb(ARRAY[
//       ast.string('id'),
//       ast.string('name')
//     ])::jsonb
//     )
// );
//   `
//   );
//   expect(result).toMatchSnapshot();
// });

it('drop_stmt', async () => {
  for (const obj of [
    ['my-schema', 'my-function', 'DROP_RESTRICT'],
    ['myschema', 'myfunction', 'DROP_RESTRICT']
  ]) {
    const [schema_name, index_name, behavior] = obj;

    const [{ deparse: result }] = await db.any(
      `select deparser.deparse(
      ast.drop_stmt(
        v_objects:= to_jsonb(ARRAY[
          to_jsonb(ARRAY[
            ast.string($1::text),
            ast.string($2::text)
          ])
        ]),
        v_removeType:= 'OBJECT_INDEX',
        v_behavior:= $3
      )
);
  `,
      [schema_name, index_name, behavior]
    );
    expect(result).toMatchSnapshot();
  }
});

it('drop_stmt 1', async () => {
  for (const obj of [
    ['my-schema', 'my-table', 'DROP_RESTRICT'],
    ['myschema', 'mytable', 'DROP_RESTRICT']
  ]) {
    const [schema_name, table_name, behavior] = obj;

    const [{ deparse: result }] = await db.any(
      `select deparser.deparse(
      ast.drop_stmt(
        v_objects:= to_jsonb(ARRAY[
          to_jsonb(ARRAY[
            ast.string($1::text),
            ast.string($2::text)
          ])
        ]),
        v_removeType:= 'OBJECT_TABLE',
        v_behavior:= $3
      )
);
  `,
      [schema_name, table_name, behavior]
    );
    expect(result).toMatchSnapshot();
  }
});
const str = (s) => ({
  String: {
    str: s
  }
});

it('drop_stmt 2', async () => {
  for (const obj of [
    [
      [
        ['some-schema', 'some-table'],
        ['someschema', 'sometable'],
        ['sometable'],
        ['some-table']
      ],
      'DROP_CASCADE'
    ],
    [[['myschema', 'mytable']], 'DROP_RESTRICT']
  ]) {
    const [relations, behavior] = obj;

    const [{ deparse: result }] = await db.any(
      `select deparser.deparse(
      ast.drop_stmt(
        v_objects:= $1::jsonb,
        v_removeType:= 'OBJECT_TABLE',
        v_behavior:= $2
      )
);
  `,
      [
        JSON.stringify(
          relations.map((rel) => {
            const [schema_name, rel_name] = rel;
            return rel_name
              ? [str(schema_name), str(rel_name)]
              : [str(schema_name)];
          })
        ),
        behavior
      ]
    );
    expect(result).toMatchSnapshot();
  }
});

it('drop_stmt 3', async () => {
  for (const obj of [
    ['schema-name', 'my-func', 'int', 'DROP_RESTRICT'],
    ['schema-name', 'myfunction', 'int', 'DROP_RESTRICT'],
    ['schemaname', 'my-func', 'int', 'DROP_RESTRICT']
  ]) {
    const [schema_name, function_name, param_type, behavior] = obj;

    const [{ deparse: result }] = await db.any(
      `select deparser.deparse(ast.drop_stmt(
      v_objects:= to_jsonb(ARRAY[
        ast.object_with_args(
          v_objname := to_jsonb(ARRAY[
            ast.string($1::text),
            ast.string($2::text)
          ]),
          v_objargs := to_jsonb(ARRAY[
            ast.string($3::text)
          ])  
        )
      ]),
      v_removeType:= 'OBJECT_FUNCTION',
      v_behavior:= $4
    )
);
  `,
      [schema_name, function_name, param_type, behavior]
    );
    expect(result).toMatchSnapshot();
  }
});

const renderArgs = (args) => {
  return args.map((arg) => {
    return str(arg);
  });
};

const objectWithArgs = (params) => {
  const [schema, rel, args] = params;
  if (schema) {
    return {
      ObjectWithArgs: {
        objname: [str(schema), str(rel)],
        objargs: renderArgs(args)
      }
    };
  } else {
    return {
      ObjectWithArgs: {
        objname: [str(rel)],
        objargs: renderArgs(args)
      }
    };
  }
};

it('drop_stmt drop', async () => {
  for (const obj of [
    [
      [
        ['some-schema', 'some-function', ['int']],
        ['someschema', 'somefunction', ['int', 'bool']],
        [null, 'somefunction', []],
        [null, 'some-function', ['text[]']]
      ],
      'DROP_CASCADE'
    ],
    [
      [
        ['some-schema', 'some-function', ['int']],
        ['someschema', 'somefunction', ['int', 'bool']],
        [null, 'somefunction', []],
        [null, 'somefunction', ['text[]']]
      ],
      'DROP_RESTRICT'
    ]
  ]) {
    const [fns, behavior] = obj;
    const [{ deparse: result }] = await db.any(
      `select deparser.deparse(
      ast.drop_stmt(
        v_objects:= $1::jsonb,
        v_removeType:= 'OBJECT_FUNCTION',
        v_behavior:= $2
      )
);
  `,
      [
        JSON.stringify(
          fns.map((fn) => {
            return objectWithArgs(fn);
          })
        ),
        behavior
      ]
    );
    expect(result).toMatchSnapshot();
  }
});

it('trans_stmt_begin', async () => {
  const [{ deparse: result }] = await db.any(
    `
    select deparser.deparse(
      ast.transaction_stmt(
        v_kind := 'TRANS_STMT_BEGIN'
      )
    );
    `
  );
  expect(result).toMatchSnapshot();
});

it('trans_stmt_begin_isolation', async () => {
 
  for (const level of ['read committed', 'repeatable read', 'serializable']) {
    const [{ deparse: result }] = await db.any(
      `
      select deparser.deparse(
        ast.transaction_stmt(
          v_kind := 'TRANS_STMT_BEGIN',
          v_options := to_jsonb(ARRAY[
            ast.def_elem(
              v_defname := 'transaction_isolation',
              v_arg := ast.a_const(v_val := ast.string($1::text))
            )
          ])
        )
      );
      `, level
    );
    expect(result).toMatchSnapshot();
  }
});