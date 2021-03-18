import { cleanTree, cleanLines, getConnections } from '../utils';
import { readFileSync } from 'fs';
import { sync as glob } from 'glob';

const FIXTURE_DIR = `${__dirname}/../__future__`;
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

export const check = async (file) => {
  const testsql = glob(`${FIXTURE_DIR}/${file}.sql`).map((f) =>
    readFileSync(f, 'utf-8')
  )[0];
  const testjson = glob(`${FIXTURE_DIR}/${file}.json`).map((f) =>
    JSON.parse(readFileSync(f, 'utf-8'))
  )[0];

  const tree = testjson.query.stmts.map(({ stmt, stmt_len }) => ({
    RawStmt: { stmt, stmt_len }
  }));

  //   console.log(testjson);

  const [{ expressions_array: result }] = await db.any(
    `select deparser.expressions_array( $1::jsonb );`,
    JSON.stringify(tree)
  );
  const sql = result.join('\n');
  console.log(sql);
  console.log(testsql);

  expect(cleanLines(sql)).toMatchSnapshot();
};

it('include-index', async () => {
  await check('include-index');
});

it('add-generated', async () => {
  await check('add-generated');
});

it('generated', async () => {
  await check('generated');
});
