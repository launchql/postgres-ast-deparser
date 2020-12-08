import { Schema, Query } from 'pg-query-string';
import { getConnections } from '../../utils';
import initObjects from '../../utils/generic';
import { assertFailureWithTx } from '../../utils/assertions';
import { snap } from '../../utils/snaps';
import { USER_PROFILES_TABLE, USER_SETTINGS_TABLE } from '../../utils/generic';

let db, api, teardown;
const objs = {
  tables: {}
};

let qString;
let query;

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  await initObjects({ objs, db });
  query = new Query({ client: db, type: 1 });
  api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
  qString = {
    public: new Schema(objs.database1.schema_name),
    private: new Schema(objs.database1.private_schema_name)
  };
  const [user1] = await api.public.callAny('register', {
    email: 'pyramation@gmail.com',
    password: 'password'
  });
  const [user2] = await api.public.callAny('register', {
    email: 'dan@3daet.com',
    password: 'password'
  });
  const [user3] = await api.public.callAny('register', {
    email: 'alisa@sidefx.com',
    password: 'password'
  });
  await api.public.callAny('register', {
    email: 'd@nlynch.com',
    password: 'password'
  });
  objs.enduser1 = user1;
  objs.enduser2 = user2;
  objs.enduser3 = user3;
});

afterAll(async () => {
  try {
    await db.rollback('db');
    await db.commit();
    await teardown();
  } catch (e) {
    console.log(e);
  }
});

beforeEach(async () => {
  db.setContext({
    role: 'anonymous'
  });
});

it('current user', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const user = await query.query(
    qString.public.function('get_current_user').call()
  );
  snap(user);
});
it('create profile', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const profile = await query.query(
    qString.public.table(USER_PROFILES_TABLE).insert({
      user_id: objs.enduser1.user_id,
      profile_picture: { url: 'http://apicture.jpg', mime: 'image/jpg' }
    })
  );
  snap(profile);
});
it('only one profile per user', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  await assertFailureWithTx({
    db,
    async try() {
      await query.query(
        qString.public.table(USER_PROFILES_TABLE).insert({
          user_id: objs.enduser1.user_id
        })
      );
    },
    async assert(e) {
      expect(e.message).toEqual(
        'duplicate key value violates unique constraint "user_profiles_user_id_key"'
      );
    }
  });
});
it('only profile owned by user', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  await assertFailureWithTx({
    db,
    async try() {
      await query.query(
        qString.public.table(USER_PROFILES_TABLE).insert({
          user_id: objs.enduser2.user_id // THIS IS NOT user1!
        })
      );
    },
    async assert(e) {
      expect(e.message).toEqual(
        'new row violates row-level security policy for table "user_profiles"'
      );
    }
  });
});
it('profile visible by other users', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser2.user_id
  });
  const profile = await query.query(
    qString.public.table(USER_PROFILES_TABLE).select(['*'], {
      user_id: objs.enduser1.user_id
    })
  );
  snap(profile);
});
it('create settings', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id
  });
  const settings = await query.query(
    qString.public.table(USER_SETTINGS_TABLE).insert({
      user_id: objs.enduser1.user_id
    })
  );
  snap(settings);
});
it('set lat/lng', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser2.user_id
  });
  const q = `INSERT INTO "${objs.database1.schema_name}".user_settings
    (user_id, location)
    VALUES
    ($1, 
      ST_SETSRID(
      POINT($2, $3)::geometry
      , 4326))
   RETURNING *`;
  const res = await db.one(q, [objs.enduser2.user_id, 118.4695, 33.985]);
  snap(res);
});
it('get settings', async () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser2.user_id
  });
  const settings = await query.query(
    qString.public.table(USER_SETTINGS_TABLE).select(['*'], {
      user_id: objs.enduser2.user_id
    })
  );
  snap(settings);
});
