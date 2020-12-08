import { getConnections } from '../../utils';
import init from '../../customers/meta';
import { snap } from '../../utils/snaps';

let db, api, teardown;
const objs = {
  tables: {},
  domains: {},
  apis: {},
  sites: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  await init({ objs, db });
  api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
});

afterAll(async () => {
  try {
    // await db.rollback('db');
    await db.commit();
    // await teardown();
  } catch (e) {
    console.log(e);
  }
});

const auth = () => {
  db.setContext({
    role: 'authenticated',
    'jwt.claims.user_id': objs.enduser1.user_id,
    'jwt.claims.group_ids': '{' + objs.enduser1.user_id + '}'
  });
};

beforeEach(async () => {
  db.setContext({
    role: 'anonymous'
  });
});

it('register user', async () => {
  const [user1] = await api.public.callAny('register', {
    email: 'pyramation@gmail.com',
    password: 'password'
  });
  objs.enduser1 = user1;
  snap(objs.enduser1);
});

const registerDomain = async ({ domain, subdomain }) => {
  const obj = await api.public.insertOne('domains', {
    owner_id: objs.enduser1.user_id,
    domain,
    subdomain
  });
  objs.domains[subdomain] = obj;
  snap(obj);
};

it('register domain', async () => {
  auth();

  await registerDomain({ subdomain: 'api', domain: 'lql.io' });
  await registerDomain({ subdomain: 'app', domain: 'lql.io' });
  await registerDomain({ subdomain: 'admin', domain: 'lql.io' });
  const obj = await api.public.insertOne('domains', {
    owner_id: objs.enduser1.user_id,
    domain: 'lql.io'
  });
  objs.domains.base = obj;
});

const registerApi = async ({ domain, schemas, anon_role, role_name }) => {
  const obj = await api.public.insertOne(
    'apis',
    {
      owner_id: objs.enduser1.user_id,
      domain_id: domain.id,
      schemas,
      anon_role,
      role_name
    },
    {
      schemas: 'text[]'
    }
  );
  objs.apis[domain.subdomain] = obj;

  obj.dbname = 'my-database';
  snap(obj);
};

it('register apis', async () => {
  auth();

  await registerApi({
    domain: objs.domains.api,
    schemas: [objs.database1.schema_name],
    anon_role: 'anonymous',
    role_name: 'authenticated'
  });
  await registerApi({
    domain: objs.domains.admin,
    schemas: [objs.database1.schema_name, objs.database1.private_schema_name],
    anon_role: 'administrator',
    role_name: 'administrator'
  });
});

const registerSite = async ({ domain, title, description }) => {
  const obj = await api.public.insertOne('sites', {
    owner_id: objs.enduser1.user_id,
    domain_id: domain.id,
    title,
    description
  });
  objs.sites[domain.subdomain] = obj;

  obj.dbname = 'my-database';
  snap(obj);
};

const registerSiteModule = async ({ site, name, data }) => {
  const obj = await api.public.insertOne(
    'site_modules',
    {
      site_id: site.id,
      name,
      data: JSON.stringify(data)
    },
    {
      data: 'jsonb'
    }
  );
  snap(obj);
};

const registerApiModule = async ({ apiObj, name, data }) => {
  const obj = await api.public.insertOne(
    'api_modules',
    {
      api_id: apiObj.id,
      name,
      data: JSON.stringify(data)
    },
    {
      data: 'jsonb'
    }
  );
  snap(obj);
};

it('register sites', async () => {
  auth();

  await registerSite({
    domain: objs.domains.app,
    title: 'Website Title',
    description: 'Website Description'
  });
});

it('register modules', async () => {
  auth();

  registerSiteModule({
    site: objs.sites.app,
    name: 'legal-emails',
    data: {
      supportEmail: 'support@launchql.com'
    }
  });

  registerApiModule({
    apiObj: objs.apis.api,
    name: 'rls_module',
    data: {
      authenticate_schema: 'meta_private',
      authenticate: 'authenticate'
    }
  });

  registerSiteModule({
    site: objs.sites.app,
    name: 'user_auth_module',
    data: {
      auth_schema: 'meta_public',
      sign_in: 'login',
      sign_up: 'register',
      set_password: 'set_password',
      reset_password: 'reset_password',
      forgot_password: 'forgot_password',
      send_verification_email: 'send_verification_email',
      verify_email: 'verify_email'
    }
  });
});
