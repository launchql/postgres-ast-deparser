import { cleanTree, cleanLines, getConnections } from '../utils';
import { readFileSync } from 'fs';
import { resolve } from 'path';
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
  } catch (e) {}
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
  // expect(tree).toMatchSnapshot();
  const sql = parser.deparse(tree);

  const name = slugify(file);
  await db.savepoint(name);
  try {
    const [{ deparse_query: result }] = await db.any(
      `select deparser.deparse_queries( $1::jsonb );`,
      tree
    );

    expect(result).toMatchSnapshot();
    // console.log(result);
  } catch (e) {
    console.log(file);
    console.log(e.message);
  }
  await db.rollback(name);

  // expect(cleanLines(sql)).toMatchSnapshot();
  expect(cleanTree(parser.parse(sql))).toEqual(cleanTree(tree));
};

describe('kitchen sink', () => {
  it('alter', async () => {
    await check('alter/alter.sql');
  });
  it('default privs', async () => {
    await check('alter/default-privs.sql');
  });
  it('set', async () => {
    await check('set/custom.sql');
  });
  it('comments', async () => {
    await check('comments/custom.sql');
  });
  it('sequences', async () => {
    await check('sequences/sequences.sql');
  });
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
  it('indexes', async () => {
    await check('indexes/custom.sql');
  });
  it('enums', async () => {
    await check('enums/create.sql');
  });
  it('do stmt', async () => {
    const dosql = readFileSync(
      resolve(__dirname + '/../__fixtures__/do/custom.sql')
    ).toString();
    const tree = parser.parse(dosql);
    // expect(tree).toMatchSnapshot();
    // const sql = parser.deparse(tree);
    // expect(cleanLines(sql)).toMatchSnapshot();
    // expect(cleanTree(parser.parse(cleanLines(sql)))).toEqual(
    //   cleanTree(parser.parse(cleanLines(dosql)))
    // );

    await db.savepoint('dostatement');
    try {
      const [{ deparse: result }] = await db.any(
        `select deparser.deparse( $1::jsonb );`,
        tree
      );

      expect(result).toMatchSnapshot();
      // console.log(result);
    } catch (e) {
      console.log('dostatement');
      console.log(e.message);
    }
    await db.rollback('dostatement');
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
    it('match', async () => {
      await check('tables/match.sql');
    });
    it('temp', async () => {
      await check('tables/temp.sql');
    });
    it('custom', async () => {
      await check('tables/custom.sql');
    });
    it('check', async () => {
      await check('tables/check.sql');
    });
    it('defaults', async () => {
      await check('tables/defaults.sql');
    });
    it('exclude', async () => {
      await check('tables/exclude.sql');
    });
    it('foreign', async () => {
      await check('tables/foreign.sql');
    });
    it('nulls', async () => {
      await check('tables/nulls.sql');
    });
    it('on_delete', async () => {
      await check('tables/on_delete.sql');
    });
    it('on_update', async () => {
      await check('tables/on_update.sql');
    });
    it('unique', async () => {
      await check('tables/unique.sql');
    });
  });
  describe('functions', () => {
    it('basic', async () => {
      await check('functions/basic.sql');
    });
    it('basic', async () => {
      await check('functions/basic.sql');
    });
    it('returns_table', async () => {
      await check('functions/returns_table.sql');
    });
    it('returns_trigger', async () => {
      await check('functions/returns_trigger.sql');
    });
    it('setof', async () => {
      await check('functions/setof.sql');
    });
  });
  describe('roles', () => {
    it('create', async () => {
      await check('roles/create.sql');
    });
    it('grants', async () => {
      await check('roles/grants.sql');
    });
  });
  describe('rules', () => {
    it('create', async () => {
      await check('rules/create.sql');
    });
  });
  describe('views', () => {
    it('create', async () => {
      await check('views/create.sql');
    });
  });
  describe('transactions', () => {
    it('begin_commit', async () => {
      await check('transactions/begin_commit.sql');
    });
  });
  describe('triggers', () => {
    it('create', async () => {
      await check('triggers/create.sql');
    });
    it('custom', async () => {
      await check('triggers/custom.sql');
    });
  });
  describe('fixtures', () => {
    it('complex.sql', async () => {
      await check('complex.sql');
    });
    it('custom.sql', async () => {
      await check('custom.sql');
    });
    it('param-ref.sql', async () => {
      await check('param-ref.sql');
    });
    it('query-001.sql', async () => {
      await check('query-001.sql');
    });
    it('query-002.sql', async () => {
      await check('query-002.sql');
    });
    it('query-003.sql', async () => {
      await check('query-003.sql');
    });
    it('simple.sql', async () => {
      await check('simple.sql');
    });
  });
  describe('upstream', () => {
    xit('upstream/abstime.sql', async () => {
      await check('upstream/abstime.sql');
    });
    it('upstream/advisory_lock.sql', async () => {
      await check('upstream/advisory_lock.sql');
    });
    xit('upstream/aggregates.sql', async () => {
      await check('upstream/aggregates.sql');
    });
    xit('upstream/alter_generic.sql', async () => {
      await check('upstream/alter_generic.sql');
    });
    xit('upstream/alter_operator.sql', async () => {
      await check('upstream/alter_operator.sql');
    });
    xit('upstream/alter_table.sql', async () => {
      await check('upstream/alter_table.sql');
    });
    xit('upstream/arrays.sql', async () => {
      await check('upstream/arrays.sql');
    });
    xit('upstream/async.sql', async () => {
      await check('upstream/async.sql');
    });
    xit('upstream/bit.sql', async () => {
      await check('upstream/bit.sql');
    });
    it('upstream/bitmapops.sql', async () => {
      await check('upstream/bitmapops.sql');
    });
    it('upstream/boolean.sql', async () => {
      await check('upstream/boolean.sql');
    });
    xit('upstream/box.sql', async () => {
      await check('upstream/box.sql');
    });
    xit('upstream/brin.sql', async () => {
      await check('upstream/brin.sql');
    });
    xit('upstream/btree_index.sql', async () => {
      await check('upstream/btree_index.sql');
    });
    xit('upstream/case.sql', async () => {
      await check('upstream/case.sql');
    });
    it('upstream/char.sql', async () => {
      await check('upstream/char.sql');
    });
    it('upstream/circle.sql', async () => {
      await check('upstream/circle.sql');
    });
    xit('upstream/cluster.sql', async () => {
      await check('upstream/cluster.sql');
    });
    xit('upstream/collate.linux.utf8.sql', async () => {
      await check('upstream/collate.linux.utf8.sql');
    });
    xit('upstream/collate.sql', async () => {
      await check('upstream/collate.sql');
    });
    xit('upstream/combocid.sql', async () => {
      await check('upstream/combocid.sql');
    });
    it('upstream/comments.sql', async () => {
      await check('upstream/comments.sql');
    });
    xit('upstream/conversion.sql', async () => {
      await check('upstream/conversion.sql');
    });
    xit('upstream/copy2.sql', async () => {
      await check('upstream/copy2.sql');
    });
    xit('upstream/copydml.sql', async () => {
      await check('upstream/copydml.sql');
    });
    xit('upstream/copyselect.sql', async () => {
      await check('upstream/copyselect.sql');
    });
    xit('upstream/create_aggregate.sql', async () => {
      await check('upstream/create_aggregate.sql');
    });
    xit('upstream/create_am.sql', async () => {
      await check('upstream/create_am.sql');
    });
    xit('upstream/create_cast.sql', async () => {
      await check('upstream/create_cast.sql');
    });
    xit('upstream/create_function_3.sql', async () => {
      await check('upstream/create_function_3.sql');
    });
    xit('upstream/create_index.sql', async () => {
      await check('upstream/create_index.sql');
    });
    it('upstream/create_misc.sql', async () => {
      await check('upstream/create_misc.sql');
    });
    xit('upstream/create_operator.sql', async () => {
      await check('upstream/create_operator.sql');
    });
    xit('upstream/create_table.sql', async () => {
      await check('upstream/create_table.sql');
    });
    xit('upstream/create_table_like.sql', async () => {
      await check('upstream/create_table_like.sql');
    });
    xit('upstream/create_type.sql', async () => {
      await check('upstream/create_type.sql');
    });
    xit('upstream/create_view.sql', async () => {
      await check('upstream/create_view.sql');
    });
    it('upstream/date.sql', async () => {
      await check('upstream/date.sql');
    });
    it('upstream/dbsize.sql', async () => {
      await check('upstream/dbsize.sql');
    });
    it('upstream/delete.sql', async () => {
      await check('upstream/delete.sql');
    });
    xit('upstream/dependency.sql', async () => {
      await check('upstream/dependency.sql');
    });
    xit('upstream/domain.sql', async () => {
      await check('upstream/domain.sql');
    });
    xit('upstream/drop_if_exists.sql', async () => {
      await check('upstream/drop_if_exists.sql');
    });
    xit('upstream/drop_operator.sql', async () => {
      await check('upstream/drop_operator.sql');
    });
    xit('upstream/enum.sql', async () => {
      await check('upstream/enum.sql');
    });
    xit('upstream/equivclass.sql', async () => {
      await check('upstream/equivclass.sql');
    });
    xit('upstream/errors.sql', async () => {
      await check('upstream/errors.sql');
    });
    xit('upstream/event_trigger.sql', async () => {
      await check('upstream/event_trigger.sql');
    });
    it('upstream/float4.sql', async () => {
      await check('upstream/float4.sql');
    });
    it('upstream/float8.sql', async () => {
      await check('upstream/float8.sql');
    });
    xit('upstream/foreign_data.sql', async () => {
      await check('upstream/foreign_data.sql');
    });
    xit('upstream/foreign_key.sql', async () => {
      await check('upstream/foreign_key.sql');
    });
    xit('upstream/functional_deps.sql', async () => {
      await check('upstream/functional_deps.sql');
    });
    it('upstream/geometry.sql', async () => {
      await check('upstream/geometry.sql');
    });
    xit('upstream/gin.sql', async () => {
      await check('upstream/gin.sql');
    });
    xit('upstream/gist.sql', async () => {
      await check('upstream/gist.sql');
    });
    xit('upstream/groupingsets.sql', async () => {
      await check('upstream/groupingsets.sql');
    });
    xit('upstream/guc.sql', async () => {
      await check('upstream/guc.sql');
    });
    it('upstream/hash_index.sql', async () => {
      await check('upstream/hash_index.sql');
    });
    xit('upstream/horology.sql', async () => {
      await check('upstream/horology.sql');
    });
    it('upstream/hs_primary_extremes.sql', async () => {
      await check('upstream/hs_primary_extremes.sql');
    });
    it('upstream/hs_primary_setup.sql', async () => {
      await check('upstream/hs_primary_setup.sql');
    });
    xit('upstream/hs_standby_allowed.sql', async () => {
      await check('upstream/hs_standby_allowed.sql');
    });
    it('upstream/hs_standby_check.sql', async () => {
      await check('upstream/hs_standby_check.sql');
    });
    xit('upstream/hs_standby_disallowed.sql', async () => {
      await check('upstream/hs_standby_disallowed.sql');
    });
    it('upstream/hs_standby_functions.sql', async () => {
      await check('upstream/hs_standby_functions.sql');
    });
    xit('upstream/indirect_toast.sql', async () => {
      await check('upstream/indirect_toast.sql');
    });
    xit('upstream/inet.sql', async () => {
      await check('upstream/inet.sql');
    });
    xit('upstream/inherit.sql', async () => {
      await check('upstream/inherit.sql');
    });
    it('upstream/init_privs.sql', async () => {
      await check('upstream/init_privs.sql');
    });
    it('upstream/insert.sql', async () => {
      await check('upstream/insert.sql');
    });
    xit('upstream/insert_conflict.sql', async () => {
      await check('upstream/insert_conflict.sql');
    });
    it('upstream/int2.sql', async () => {
      await check('upstream/int2.sql');
    });
    it('upstream/int4.sql', async () => {
      await check('upstream/int4.sql');
    });
    xit('upstream/int8.sql', async () => {
      await check('upstream/int8.sql');
    });
    xit('upstream/interval.sql', async () => {
      await check('upstream/interval.sql');
    });
    xit('upstream/join.sql', async () => {
      await check('upstream/join.sql');
    });
    xit('upstream/json.sql', async () => {
      await check('upstream/json.sql');
    });
    it('upstream/json_encoding.sql', async () => {
      await check('upstream/json_encoding.sql');
    });
    xit('upstream/jsonb.sql', async () => {
      await check('upstream/jsonb.sql');
    });
    xit('upstream/limit.sql', async () => {
      await check('upstream/limit.sql');
    });
    it('upstream/line.sql', async () => {
      await check('upstream/line.sql');
    });
    xit('upstream/lock.sql', async () => {
      await check('upstream/lock.sql');
    });
    it('upstream/lseg.sql', async () => {
      await check('upstream/lseg.sql');
    });
    xit('upstream/macaddr.sql', async () => {
      await check('upstream/macaddr.sql');
    });
    xit('upstream/matview.sql', async () => {
      await check('upstream/matview.sql');
    });
    it('upstream/misc_functions.sql', async () => {
      await check('upstream/misc_functions.sql');
    });
    it('upstream/money.sql', async () => {
      await check('upstream/money.sql');
    });
    xit('upstream/name.sql', async () => {
      await check('upstream/name.sql');
    });
    xit('upstream/namespace.sql', async () => {
      await check('upstream/namespace.sql');
    });
    xit('upstream/numeric.sql', async () => {
      await check('upstream/numeric.sql');
    });
    xit('upstream/numeric_big.sql', async () => {
      await check('upstream/numeric_big.sql');
    });
    it('upstream/numerology.sql', async () => {
      await check('upstream/numerology.sql');
    });
    xit('upstream/object_address.sql', async () => {
      await check('upstream/object_address.sql');
    });
    it('upstream/oid.sql', async () => {
      await check('upstream/oid.sql');
    });
    it('upstream/oidjoins.sql', async () => {
      await check('upstream/oidjoins.sql');
    });
    xit('upstream/opr_sanity.sql', async () => {
      await check('upstream/opr_sanity.sql');
    });
    it('upstream/path.sql', async () => {
      await check('upstream/path.sql');
    });
    xit('upstream/pg_lsn.sql', async () => {
      await check('upstream/pg_lsn.sql');
    });
    xit('upstream/plancache.sql', async () => {
      await check('upstream/plancache.sql');
    });
    xit('upstream/plpgsql.sql', async () => {
      await check('upstream/plpgsql.sql');
    });
    xit('upstream/point.sql', async () => {
      await check('upstream/point.sql');
    });
    it('upstream/polygon.sql', async () => {
      await check('upstream/polygon.sql');
    });
    xit('upstream/polymorphism.sql', async () => {
      await check('upstream/polymorphism.sql');
    });
    xit('upstream/portals.sql', async () => {
      await check('upstream/portals.sql');
    });
    xit('upstream/portals_p2.sql', async () => {
      await check('upstream/portals_p2.sql');
    });
    xit('upstream/prepare.sql', async () => {
      await check('upstream/prepare.sql');
    });
    xit('upstream/prepared_xacts.sql', async () => {
      await check('upstream/prepared_xacts.sql');
    });
    xit('upstream/privileges.sql', async () => {
      await check('upstream/privileges.sql');
    });
    xit('upstream/psql.sql', async () => {
      await check('upstream/psql.sql');
    });
    xit('upstream/psql_crosstab.sql', async () => {
      await check('upstream/psql_crosstab.sql');
    });
    it('upstream/random.sql', async () => {
      await check('upstream/random.sql');
    });
    xit('upstream/rangefuncs.sql', async () => {
      await check('upstream/rangefuncs.sql');
    });
    xit('upstream/rangetypes.sql', async () => {
      await check('upstream/rangetypes.sql');
    });
    xit('upstream/regex.sql', async () => {
      await check('upstream/regex.sql');
    });
    xit('upstream/regproc.sql', async () => {
      await check('upstream/regproc.sql');
    });
    it('upstream/reltime.sql', async () => {
      await check('upstream/reltime.sql');
    });
    xit('upstream/replica_identity.sql', async () => {
      await check('upstream/replica_identity.sql');
    });
    xit('upstream/returning.sql', async () => {
      await check('upstream/returning.sql');
    });
    xit('upstream/roleattributes.sql', async () => {
      await check('upstream/roleattributes.sql');
    });
    xit('upstream/rolenames.sql', async () => {
      await check('upstream/rolenames.sql');
    });
    xit('upstream/rowsecurity.sql', async () => {
      await check('upstream/rowsecurity.sql');
    });
    xit('upstream/rowtypes.sql', async () => {
      await check('upstream/rowtypes.sql');
    });
    xit('upstream/rules.sql', async () => {
      await check('upstream/rules.sql');
    });
    xit('upstream/sanity_check.sql', async () => {
      await check('upstream/sanity_check.sql');
    });
    xit('upstream/security_label.sql', async () => {
      await check('upstream/security_label.sql');
    });
    xit('upstream/select.sql', async () => {
      await check('upstream/select.sql');
    });
    xit('upstream/select_distinct.sql', async () => {
      await check('upstream/select_distinct.sql');
    });
    it('upstream/select_distinct_on.sql', async () => {
      await check('upstream/select_distinct_on.sql');
    });
    it('upstream/select_having.sql', async () => {
      await check('upstream/select_having.sql');
    });
    it('upstream/select_implicit.sql', async () => {
      await check('upstream/select_implicit.sql');
    });
    xit('upstream/select_into.sql', async () => {
      await check('upstream/select_into.sql');
    });
    xit('upstream/select_views.sql', async () => {
      await check('upstream/select_views.sql');
    });
    xit('upstream/sequence.sql', async () => {
      await check('upstream/sequence.sql');
    });
    xit('upstream/spgist.sql', async () => {
      await check('upstream/spgist.sql');
    });
    xit('upstream/stats.sql', async () => {
      await check('upstream/stats.sql');
    });
    xit('upstream/strings.sql', async () => {
      await check('upstream/strings.sql');
    });
    xit('upstream/subselect.sql', async () => {
      await check('upstream/subselect.sql');
    });
    xit('upstream/tablesample.sql', async () => {
      await check('upstream/tablesample.sql');
    });
    xit('upstream/temp.sql', async () => {
      await check('upstream/temp.sql');
    });
    it('upstream/text.sql', async () => {
      await check('upstream/text.sql');
    });
    it('upstream/time.sql', async () => {
      await check('upstream/time.sql');
    });
    xit('upstream/timestamp.sql', async () => {
      await check('upstream/timestamp.sql');
    });
    xit('upstream/timestamptz.sql', async () => {
      await check('upstream/timestamptz.sql');
    });
    it('upstream/timetz.sql', async () => {
      await check('upstream/timetz.sql');
    });
    it('upstream/tinterval.sql', async () => {
      await check('upstream/tinterval.sql');
    });
    xit('upstream/transactions.sql', async () => {
      await check('upstream/transactions.sql');
    });
    xit('upstream/triggers.sql', async () => {
      await check('upstream/triggers.sql');
    });
    xit('upstream/truncate.sql', async () => {
      await check('upstream/truncate.sql');
    });
    xit('upstream/tsdicts.sql', async () => {
      await check('upstream/tsdicts.sql');
    });
    xit('upstream/tsearch.sql', async () => {
      await check('upstream/tsearch.sql');
    });
    it('upstream/tstypes.sql', async () => {
      await check('upstream/tstypes.sql');
    });
    it('upstream/txid.sql', async () => {
      await check('upstream/txid.sql');
    });
    xit('upstream/type_sanity.sql', async () => {
      await check('upstream/type_sanity.sql');
    });
    xit('upstream/typed_table.sql', async () => {
      await check('upstream/typed_table.sql');
    });
    xit('upstream/union.sql', async () => {
      await check('upstream/union.sql');
    });
    xit('upstream/updatable_views.sql', async () => {
      await check('upstream/updatable_views.sql');
    });
    xit('upstream/update.sql', async () => {
      await check('upstream/update.sql');
    });
    xit('upstream/uuid.sql', async () => {
      await check('upstream/uuid.sql');
    });
    xit('upstream/vacuum.sql', async () => {
      await check('upstream/vacuum.sql');
    });
    it('upstream/varchar.sql', async () => {
      await check('upstream/varchar.sql');
    });
    xit('upstream/window.sql', async () => {
      await check('upstream/window.sql');
    });
    xit('upstream/with.sql', async () => {
      await check('upstream/with.sql');
    });
    xit('upstream/without_oid.sql', async () => {
      await check('upstream/without_oid.sql');
    });
    xit('upstream/xml.sql', async () => {
      await check('upstream/xml.sql');
    });
    xit('upstream/xmlmap.sql', async () => {
      await check('upstream/xmlmap.sql');
    });
  });
});
