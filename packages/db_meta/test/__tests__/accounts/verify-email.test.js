import { getConnections } from '../../utils';
import initObjects from '../../utils/generic';
import { snap } from '../../utils/snaps';

let db, api, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  await initObjects({ objs, db });
  api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
  const [user1] = await api.public.callAny('register', {
    email: 'pyramation@gmail.com',
    password: 'password'
  });
  objs.enduser1 = user1;
});

afterAll(async () => {
  try {
    await teardown();
  } catch (e) {
    console.log(e);
  }
});

afterEach(async () => {
  try {
    await db.rollback('db');
    await db.commit();
  } catch (e) {
    console.log(e);
  }
});

beforeEach(async () => {
  await db.begin();
  await db.savepoint('db');
  db.setContext({
    role: 'anonymous'
  });
});

describe('send_verification_email', () => {
  beforeEach(async () => {
    await api.public.callAny('send_verification_email', {
      email: 'pyramation@gmail.com'
    });
    db.setContext({
      role: 'postgres'
    });
    const job = await db.one(`
    SELECT * FROM "${objs.schemas.jobs}".jobs
    WHERE task_identifier='user_emails__send_verification'
    AND payload->>'email' = 'pyramation@gmail.com'
  `);
    snap(job);
    objs.email_id = job.payload.email_id;
    objs.verification_token = job.payload.verification_token;
  });
  it('within range', async () => {
    const [{ verify_email }] = await api.public.callAny('verify_email', {
      email_id: objs.email_id,
      token: objs.verification_token
    });
    expect(verify_email).toBe(true);
  });

  it('verify after expires', async () => {
    const user_id = objs.enduser1.user_id;
    const s = objs.schemas.simple_secrets;

    const { past_date } = await db.one(
      `
      SELECT ("${s}".get($1, $2))::timestamptz - interval '4 days'::interval as past_date
    `,
      [user_id, 'verification_email_sent_at']
    );

    await db.any(
      `
      SELECT "${s}".set($1, $2::text, $3::text)
    `,
      [user_id, 'verification_email_sent_at', past_date]
    );

    const [{ verify_email }] = await api.public.callAny('verify_email', {
      email_id: objs.email_id,
      token: objs.verification_token
    });
    expect(verify_email).toBe(false);
  });

  it('before min duration between emails', async () => {
    const user_id = objs.enduser1.user_id;
    const s = objs.schemas.simple_secrets;

    const { one_min_ago } = await db.one(
      `
      SELECT ("${s}".get($1, $2))::timestamptz - interval '1 minutes'::interval as one_min_ago
    `,
      [user_id, 'verification_email_sent_at']
    );

    await db.any(
      `
      SELECT "${s}".set($1, $2::text, $3::text)
    `,
      [user_id, 'verification_email_sent_at', one_min_ago]
    );

    const [{ send_verification_email }] = await api.public.callAny(
      'send_verification_email',
      {
        email: 'pyramation@gmail.com'
      }
    );

    // NULL means that it's within the duration that we throttle emails
    expect(send_verification_email).toBe(null);
  });

  it('before min duration between new tokens', async () => {
    const user_id = objs.enduser1.user_id;
    const s = objs.schemas.simple_secrets;

    const { few_mins } = await db.one(
      `
      SELECT ("${s}".get($1, $2))::timestamptz - interval '7 minutes'::interval as few_mins
    `,
      [user_id, 'verification_email_sent_at']
    );

    await db.any(
      `
      SELECT "${s}".set($1, $2::text, $3::text)
    `,
      [user_id, 'verification_email_sent_at', few_mins]
    );

    const [{ send_verification_email }] = await api.public.callAny(
      'send_verification_email',
      {
        email: 'pyramation@gmail.com'
      }
    );
    expect(send_verification_email).toBe(true);

    db.setContext({
      role: 'postgres'
    });
    const jobs = await db.many(`
    SELECT * FROM "${objs.schemas.jobs}".jobs
    WHERE task_identifier='user_emails__send_verification'
    AND payload->>'email' = 'pyramation@gmail.com'
  `);

    expect(jobs.length).toBe(2);
    expect(jobs[0].payload.verification_token).toEqual(
      jobs[1].payload.verification_token
    );
  });

  it('after min duration between new tokens', async () => {
    const user_id = objs.enduser1.user_id;
    const s = objs.schemas.simple_secrets;

    const { few_more_mins } = await db.one(
      `
      SELECT ("${s}".get($1, $2))::timestamptz - interval '11 minutes'::interval as few_more_mins
    `,
      [user_id, 'verification_email_sent_at']
    );

    await db.any(
      `
      SELECT "${s}".set($1, $2::text, $3::text)
    `,
      [user_id, 'verification_email_sent_at', few_more_mins]
    );

    const [{ send_verification_email }] = await api.public.callAny(
      'send_verification_email',
      {
        email: 'pyramation@gmail.com'
      }
    );
    expect(send_verification_email).toBe(true);

    db.setContext({
      role: 'postgres'
    });
    const jobs = await db.many(`
    SELECT * FROM "${objs.schemas.jobs}".jobs
    WHERE task_identifier='user_emails__send_verification'
    AND payload->>'email' = 'pyramation@gmail.com'
  `);

    expect(jobs.length).toBe(2);
    expect(jobs[0].payload.verification_token).not.toEqual(
      jobs[1].payload.verification_token
    );
  });
});
