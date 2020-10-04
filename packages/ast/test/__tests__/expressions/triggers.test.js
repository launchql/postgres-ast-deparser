import { getConnections } from '../../utils';
import { policies } from './__fixtures__/policies';
import { triggers } from './__fixtures__/triggers';
import { functions } from './__fixtures__/functions';

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

it('create trig stmt', async () => {
  const json = triggers[0];
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( '${JSON.stringify(json)}'::jsonb );
  `);
  expect(result).toMatchSnapshot();
});

it('createtriggerstmt', async () => {
  const [result] = await db.any(`
select ast.createtriggerstmt('trigger',
    ast.rangevar('schema-name', 'mytable', true, 'p'),
    to_jsonb(ARRAY[ ast.str('tg-schema'),ast.str('tgname') ]),
    true,
    2,
    16,
    ast.aexpr(3, 
        ast.columnref(
          to_jsonb(ARRAY[ ast.str('old'),ast.str('field-a') ])
        ),
        '=',
        ast.columnref(
          to_jsonb(ARRAY[ ast.str('new'),ast.str('field-a') ])
        ) 
    )
);
  `);
  expect(result).toMatchSnapshot();
});

it('createtriggerstmt deparse', async () => {
  const [result] = await db.any(`
select deparser.deparse( 
  ast.createtriggerstmt('trigger',
    ast.rangevar('schema-name', 'mytable', true, 'p'),
    to_jsonb(ARRAY[ ast.str('tg-schema'),ast.str('tgname') ]),
    true,
    2,
    16,
    ast.aexpr(3, 
        ast.columnref(
          to_jsonb(ARRAY[ ast.str('old'),ast.str('field-a') ])
        ),
        '=',
        ast.columnref(
          to_jsonb(ARRAY[ ast.str('new'),ast.str('field-a') ])
        ) 
    )
  )
);
  `);
  expect(result).toMatchSnapshot();
});

it('createtrigger with fields', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast.create_trigger_with_fields(
    'my-trigger',
    'my-schema',
    'my-table',
    'my-tg-fn-schema',
    'my-tg-fn',  
    ARRAY['name', 'description']::text[],
    2,
    4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});

it('createtrigger with fields and names wo quotes', async () => {
  const [{ deparse: result }] = await db.any(`
select deparser.deparse( 
  ast.create_trigger_with_fields(
    'mytrigger',
    'myschema',
    'mytable',
    'mytgfnschema',
    'mytgfn',  
    ARRAY['name', 'description']::text[],
    2,
    4 | 16)
  )`);
  expect(result).toMatchSnapshot();
});
