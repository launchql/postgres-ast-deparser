import { getConnections } from '../utils';
import { snap } from '../utils/snaps';

let db, meta, collections, teardown, database_id;
const objs = {
  tables: {},
  domains: {},
  apis: {},
  sites: {}
};

const owner_id = '07281002-1699-4762-57e3-ab1b92243120';

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  // postgis...
  await db.any(`GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public to public;`);
  meta = {
    public: db.helper('meta_public'),
    private: db.helper('meta_private')
  };
  collections = {
    public: db.helper('collections_public'),
    private: db.helper('collections_private')
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

beforeEach(async () => {
  db.setContext({
    role: 'postgres'
  });
});

const createDatabase = async () => {
  const obj = await collections.public.insertOne('database', {
    owner_id,
    name: 'my-meta-db'
  });
  objs.db = obj;
  database_id = obj.id;
  snap(obj);
};

const registerDomain = async ({ domain, subdomain }) => {
  const obj = await meta.public.insertOne('domains', {
    database_id,
    domain,
    subdomain
  });
  objs.domains[subdomain] = obj;
  snap(obj);
};

it('create database', async () => {
  await createDatabase();
});

it('register domain', async () => {
  await registerDomain({ subdomain: 'api', domain: 'lql.io' });
  await registerDomain({ subdomain: 'app', domain: 'lql.io' });
  await registerDomain({ subdomain: 'admin', domain: 'lql.io' });
  const obj = await meta.public.insertOne('domains', {
    database_id,
    domain: 'lql.io'
  });
  objs.domains.base = obj;
});

const registerApi = async ({ domain, schemas, anon_role, role_name }) => {
  const obj = await meta.public.insertOne(
    'apis',
    {
      database_id,
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
  await registerApi({
    domain: objs.domains.api,
    schemas: ['a'],
    anon_role: 'anonymous',
    role_name: 'authenticated'
  });
  await registerApi({
    domain: objs.domains.admin,
    schemas: ['b', 'soon link this with a fkey'],
    anon_role: 'administrator',
    role_name: 'administrator'
  });
});

const registerSite = async ({ domain, title, description }) => {
  const obj = await meta.public.insertOne('sites', {
    database_id,
    domain_id: domain.id,
    title,
    description
  });
  objs.sites[domain.subdomain] = obj;

  obj.dbname = 'my-database';
  snap(obj);
};

const registerSiteModule = async ({ site, name, data }) => {
  const obj = await meta.public.insertOne(
    'site_modules',
    {
      database_id,
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
  const obj = await meta.public.insertOne(
    'api_modules',
    {
      database_id,
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
  await registerSite({
    domain: objs.domains.app,
    title: 'Website Title',
    description: 'Website Description'
  });
});

it('register modules', async () => {
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
