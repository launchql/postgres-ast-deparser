import { getConnection, closeConnection } from './utils';

let db;

describe('database', () => {
  beforeEach(async () => {
    db = await getConnection();
  });
  afterEach(async () => {
    await closeConnection(db);
  });
  describe('performance', () => {
    it('has indexes on all foreign keys', async () => {
      const query = `WITH indexed_tables AS (
select
    ns.nspname,
    t.relname as table_name,
    i.relname as index_name,
    array_to_string(array_agg(a.attname), ', ') as column_names,
    ix.indrelid,
    string_to_array(ix.indkey::text, ' ')::smallint[] as indkey
FROM pg_class i
JOIN pg_index ix ON i.OID = ix.indrelid
JOIN pg_class t ON ix.indrelid = t.oid
JOIN pg_namespace ns ON ns.oid = t.relnamespace
JOIN pg_attribute a ON a.attrelid = t.oid
where a.attnum = ANY(ix.indkey)
and t.relkind = 'r'
and nspname not in ('pg_catalog')
group by
    ns.nspname,
    t.relname,
    i.relname,
    ix.indrelid,
    ix.indkey
order by
    ns.nspname,
    t.relname,
    i.relname,
    ix.indrelid,
    ix.indkey
)
SELECT
  conrelid::regclass,
  conname,
  reltuples::bigint
  FROM pg_constraint pgc
  JOIN pg_class ON (conrelid = pg_class.oid)
  WHERE contype = 'f'
  AND NOT EXISTS(
    SELECT 1
    FROM indexed_tables
    WHERE indrelid = conrelid
    AND conkey = indkey
   OR (array_length(indkey, 1) > 1 AND indkey @> conkey)
  )
  ORDER BY reltuples DESC;
      `;

      const results = await db.any(query, [
        [
          'auth_public',
          'auth_private',
          'roles_public',
          'roles_private',
          'objects_public',
          'objects_private',
          'projects_public',
          'projects_private',
          'checkout_private'
        ]
      ]);
      console.log(results);
      expect(results.length).toBe(0);
    });
  });
});
