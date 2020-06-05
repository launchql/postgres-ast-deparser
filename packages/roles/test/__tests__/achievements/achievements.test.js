import { closeConnections, createUser, getConnections } from '../../utils';

let db, conn;

let objs = {};

const feature = name =>
  `(SELECT id FROM status_public.user_achievement WHERE name='${name}')`;

const task = name =>
  `(SELECT id FROM status_public.user_task WHERE name='${name}')`;

describe('achievements', () => {
  beforeEach(async () => {
    ({ db, conn } = await getConnections());
    objs.user1 = await createUser(db, undefined, 'user1');
    objs.user2 = await createUser(db, undefined, 'user2');
    objs.user3 = await createUser(db, undefined, 'user3');
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.role_id': objs.user1.id
    });
    await db.any(`
    TRUNCATE TABLE 
      status_public.user_task_achievement CASCADE;
  `);
  });
  afterEach(async () => {
    await closeConnections({ db, conn });
  });
  it('status and tasks', async () => {
    await db.any(`
      INSERT INTO 
        status_public.user_achievement (name) VALUES
      ('deploy_app');
    `);

    await db.any(`
      INSERT INTO 
        status_public.user_task (name, achievement_id, priority) VALUES
        ('invite_10_users', (SELECT id FROM status_public.user_achievement WHERE name='deploy_app'), 10);
    `);

    await db.any(`
      INSERT INTO 
        status_public.user_task_achievement (task_id, user_id) VALUES 
        (${task('accept_terms')}, '${objs.user1.id}'),
        (${task('verify_email')}, '${objs.user1.id}'),
        (${task('create_display_name')}, '${objs.user1.id}'),
        (${task('create_username')}, '${objs.user1.id}');
        `);

    await db.any(`
      INSERT INTO 
        status_public.user_task_achievement (task_id, user_id) VALUES 
        (${task('accept_terms')}, '${objs.user2.id}'),
        (${task('invite_10_users')}, '${objs.user2.id}'),
        (${task('create_username')}, '${objs.user2.id}');
        `);

    async function user_achieved(opts) {

      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': opts.user_id
      });
  
      const { user_achieved: res } = await conn.one(
        'SELECT status_public.user_achieved($1)',
        [opts.achievement]
      );
      return res;
    }

    async function tasks_required_for(opts) {
      conn.setContext({
        role: 'authenticated',
        'jwt.claims.role_id': opts.user_id
      });
  
      const res = await conn.any(
        'SELECT name FROM status_public.tasks_required_for($1)',
        [opts.achievement]
      );
      return res.map(a => a.name);
    }

    const makeCaseUserCan = name => {
      const [_has, username, _achieved, achievement] = name.split(' ');
      return {
        type: 'user_achieved',
        name,
        achievement,
        user_id: objs[username] && objs[username].id
      };
    };

    const makeCaseRequired = name => {
      const [_required, _for, username, _to, achievement] = name.split(' ');
      return {
        type: 'tasks_required_for',
        name,
        achievement,
        user_id: objs[username] && objs[username].id
      };
    };

    const fns = {
      tasks_required_for,
      user_achieved
    };

    const makeCase = name => {
      if (/^has/.test(name)) {
        return makeCaseUserCan(name);
      }
      if (/^required/.test(name)) {
        return makeCaseRequired(name);
      }
    };

    const cases = [
      makeCase('has user1 achieved profile_complete'),
      makeCase('has user1 achieved deploy_app'),
      makeCase('has user2 achieved deploy_app'),
      makeCase('has user2 achieved profile_complete'),
      makeCase('has user3 achieved deploy_app'),
      makeCase('has user3 achieved profile_complete'),
      makeCase('required for user1 to deploy_app'),
      makeCase('required for user1 to profile_complete'),
      makeCase('required for user2 to deploy_app'),
      makeCase('required for user2 to profile_complete'),
      makeCase('required for user3 to deploy_app'),
      makeCase('required for user3 to profile_complete')
    ];
    const objResults = {};
    for (let cs of cases) {
      await (async cs => {
        objResults[cs.name] = await fns[cs.type](cs);
      })(cs);
    }

    expect(objResults).toMatchSnapshot();
  });
});
