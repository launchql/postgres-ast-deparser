import { getConnections } from './utils';

let db, dbs, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  dbs = db.helper('faker');
});

afterAll(async () => {
  try {
    //try catch here allows us to see the sql parsing issues!
    await teardown();
  } catch (e) {
    // noop
  }
});

beforeEach(async () => {
  await db.beforeEach();
});

afterEach(async () => {
  await db.afterEach();
});

it('gets random words', async () => {
  const obj = {};
  const types = [
    'word',
    'sentence',
    'paragraph',
    'email',
    'integer',
    'float',
    'timestamptz',
    'date',
    'interval',
    'image',
    'image_mime',
    'mime',
    'uuid',
    'token',
    'password',
    'hostname',
    'upload',
    'username',
    'gender',
    'name',
    'surname',
    'fullname',
    'attachment',
    'birthdate',
    'ext',
    'ip',
    'business'
  ];
  for (const t of types) {
    obj[t] = await dbs.callOne(t);
  }

  obj['english-words'] = await dbs.callOne('sentence', {
    unit: 'word',
    min: 7,
    max: 20,
    cat: ['colors']
  });
  obj['mixed-words'] = await dbs.callOne('sentence', {
    unit: 'word',
    min: 7,
    max: 20,
    cat: ['colors', 'adjectives', 'surname', 'animals', 'stop', 'stop', 'stop']
  });
  obj['sentence-words'] = await dbs.callOne('sentence', {
    unit: 'word',
    min: 7,
    max: 20,
    cat: ['lorem']
  });
  obj['sentence-chars'] = await dbs.callOne('sentence', {
    unit: 'char',
    min: 100,
    max: 140,
    cat: ['lorem']
  });
  obj['paragraph-chars'] = await dbs.callOne('paragraph', {
    unit: 'char',
    min: 300,
    max: 500,
    cat: ['lorem']
  });
  obj['integer-chars'] = await dbs.callOne('integer', {
    min: 300,
    max: 500
  });
  obj['xenial'] = await dbs.callOne('birthdate', {
    min: 34,
    max: 39
  });
  console.log(obj);
});

it('businesses', async () => {
  for (let i = 0; i < 20; i++) {
    const biz = await dbs.callOne('business');
    console.log(biz);
  }
});
