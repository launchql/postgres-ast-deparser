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
