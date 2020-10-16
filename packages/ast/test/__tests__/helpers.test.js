import { cleanTree, cleanLines, getConnections } from '../utils';
import { readFileSync } from 'fs';
import { sync as glob } from 'glob';
const parser = require('pgsql-parser');

const FIXTURE_DIR = `${__dirname}/../__fixtures__`;
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

function slugify(text) {
  return text
    .toString()
    .toLowerCase()
    .replace(/\s+/g, '-') // Replace spaces with -
    .replace(/[^\w\-]+/g, '') // Remove all non-word chars
    .replace(/\-\-+/g, '-') // Replace multiple - with single -
    .replace(/^-+/, '') // Trim - from start of text
    .replace(/-+$/, ''); // Trim - from end of text
}

export const check = async (file) => {
  const testsql = glob(`${FIXTURE_DIR}/${file}`).map((f) =>
    readFileSync(f).toString()
  )[0];
  const tree = parser.parse(testsql);
  const originalTree = cleanTree(tree);

  const sqlfromparser = parser.deparse(tree);
  const [{ expressions_array: result }] = await db.any(
    `select deparser.expressions_array( $1::jsonb );`,
    JSON.stringify(tree)
  );
  const sql = result.join('\n');
  // console.log(sql);
  expect(cleanLines(sql)).toMatchSnapshot();
  expect(cleanLines(sqlfromparser)).toMatchSnapshot();
  // uncomment this to debug...
  // expect(originalTree).toMatchSnapshot();

  // VERIFY
  // const newTree = cleanTree(parser.parse(sql));
  // expect(newTree).toEqual(originalTree);
  // expect(cleanTree(parser.parse(sqlfromparser))).toEqual(originalTree);
};

it('policies', async () => {
  await check('policies/custom.sql');
});
it('grants', async () => {
  await check('grants/custom.sql');
});
it('types', async () => {
  await check('types/composite.sql');
});
it('domains', async () => {
  await check('domains/create.sql');
});
it('enums', async () => {
  await check('enums/create.sql');
});
it('indexes', async () => {
  await check('indexes/custom.sql');
});
it('insert', async () => {
  await check('statements/insert.sql');
});
it('update', async () => {
  await check('statements/update.sql');
});
it('conflicts', async () => {
  await check('statements/conflicts.sql');
});
it('delete', async () => {
  await check('statements/delete.sql');
});
it('alias', async () => {
  await check('statements/alias.sql');
});
it('domain', async () => {
  await check('domains/create.sql');
});

describe('tables', () => {
  it('match', () => {
    check('tables/match.sql');
  });
  it('temp', () => {
    check('tables/temp.sql');
  });
  it('custom', () => {
    check('tables/custom.sql');
  });
  it('check', () => {
    check('tables/check.sql');
  });
  it('defaults', () => {
    check('tables/defaults.sql');
  });
  it('exclude', () => {
    check('tables/exclude.sql');
  });
  it('foreign', () => {
    check('tables/foreign.sql');
  });
  it('nulls', () => {
    check('tables/nulls.sql');
  });
  it('on_delete', () => {
    check('tables/on_delete.sql');
  });
  it('on_update', () => {
    check('tables/on_update.sql');
  });
  it('unique', () => {
    check('tables/unique.sql');
  });
});
