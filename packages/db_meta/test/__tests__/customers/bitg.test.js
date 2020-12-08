import { getConnections } from '../../utils';

const psqlIds = (array) => {
  return `{${array.join(',')}}`;
};

import makeBitgreenPartnersTemplate from '../../customers/bitg';

// export const USER_PROFILES_TABLE = 'user_profiles';
export const USER_SECRETS_TABLE = 'user_secrets';
export const USER_ENCRYPTED_SECRETS_TABLE = 'user_encrypted_secrets';
export const USER_TOKENS_TABLE = 'api_tokens';
export const USER_TABLE = 'users';
export const GET_CURRENT_ROLE_ID = 'get_current_user_id';
export const GET_CURRENT_GROUP_IDS = 'get_current_group_ids';
export const AUTH_FUNCTION = 'authenticate';
// export const ADMIN_AUTH_FUNCTION = 'authenticate_admin';

let db, conn, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  await db.begin();
  await db.savepoint('db');
  await makeBitgreenPartnersTemplate({ objs, db, conn });
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

it('bitg db', async () => {
  const api = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
  // conn is in a different transaction!
  // so unless you commit, youre shit out of luck!

  // const api = {
  //   public: conn.helper(objs.database1.schema_name),
  //   private: conn.helper(objs.database1.private_schema_name)
  // };
  const sup = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };

  db.setContext({
    role: 'postgres'
  });

  objs.enduser1 = await sup.public.insertOne(USER_TABLE, {
    username: 'bitg-dev'
  });

  db.setContext({
    role: 'anonymous'
  });

  objs.enduser2 = await api.private.callAny('sign_up_with_bitg_address', {
    bitg_address: 'GWhXzs3hCWNasa1jX5xaSZ6h3uDgc7Lb9H'
  });

  await db.savepoint('error1');
  try {
    objs.enduser3 = await api.private.callAny('sign_up_with_bitg_address', {
      bitg_address: 'GWhXzs3hCWNasa1jX5xaSZ6h3uDgc7Lb9H'
    });
  } catch (e) {
    expect(e.message).toEqual('ACCOUNT_EXISTS');
  }
  await db.rollback('error1');

  const [{ sign_in_request_challenge: challenge }] = await api.private.callAny(
    'sign_in_request_challenge',
    {
      bitg_address: 'GWhXzs3hCWNasa1jX5xaSZ6h3uDgc7Lb9H'
    }
  );

  const result = await api.private.callAny('sign_in_with_challenge', {
    bitg_address: 'GWhXzs3hCWNasa1jX5xaSZ6h3uDgc7Lb9H',
    special_value: challenge
  });

  console.log(result);

  db.setContext({
    role: 'postgres'
  });

  await sup.private.insertOne('permissions', {
    name: 'can_create_partner',
    user_id: objs.enduser1.id
  });
  await sup.private.insertOne('permissions', {
    name: 'can_create_merchant',
    user_id: objs.enduser1.id
  });
  await sup.private.insertOne('permissions', {
    name: 'can_create_article',
    user_id: objs.enduser1.id
  });

  // insert and select projects and objects!

  await (async () => {
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.enduser1.id,
      'jwt.claims.group_ids': psqlIds([objs.enduser1.id])
    });

    const merchant = await api.public.insertOne('merchants', {
      owner_id: objs.enduser1.id,
      name: 'merchant1'
    });
    await api.public.insertOne('products', {
      merchant_id: merchant.id,
      name: 'product1'
    });
    await api.public.insertOne('products', {
      merchant_id: merchant.id,
      name: 'product2'
    });
    await api.public.insertOne('products', {
      merchant_id: merchant.id,
      name: 'product3'
    });

    const merchants = await api.public.select('merchants', ['*']);
    const products = await api.public.select('products', ['*']);

    expect(merchants.length).toBe(1);
    expect(products.length).toBe(3);
  })();

  await (async () => {
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.enduser1.id,
      'jwt.claims.group_ids': psqlIds([objs.enduser1.id])
    });

    const partner = await api.public.insertOne('partners', {
      owner_id: objs.enduser1.id,
      name: 'Amazing Partner'
    });
    const campaign = await api.public.insertOne('campaigns', {
      partner_id: partner.id,
      name: 'Amazing Campaign'
    });
    await api.public.insertOne('campaign_actions', {
      campaign_id: campaign.id,
      partner_id: partner.id,
      name: 'initiative1'
    });
    await api.public.insertOne('campaign_actions', {
      campaign_id: campaign.id,
      partner_id: partner.id,
      name: 'initiative2'
    });
    await api.public.insertOne('campaign_actions', {
      campaign_id: campaign.id,
      partner_id: partner.id,
      name: 'initiative3'
    });

    const campaigns = await api.public.select('campaigns', ['*']);
    const campaign_actions = await api.public.select('campaign_actions', ['*']);

    expect(campaigns.length).toBe(1);
    expect(campaign_actions.length).toBe(3);
  })();

  await (async () => {
    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.enduser1.id,
      'jwt.claims.group_ids': psqlIds([objs.enduser1.id])
    });

    const teslaAcccount = await api.public.insertOne('tesla_accounts', {
      owner_id: objs.enduser1.id
    });
    console.log(teslaAcccount);

    const teslaSecrets = await api.private.insertOne('tesla_secrets', {
      account_id: teslaAcccount.id,
      access_token: 'abcde',
      refresh_token: 'abcdef'
    });
    console.log(teslaSecrets);

    db.setContext({
      role: 'postgres'
    });

    const [{ encrypt_field_pgp_get: val1 }] = await db.any(`SELECT
      "${objs.database1.private_schema_name}".encrypt_field_pgp_get(access_token, account_id::text)
       FROM
       "${objs.database1.private_schema_name}".tesla_secrets`);

    expect(val1).toMatchSnapshot();

    const [{ encrypt_field_pgp_get: val2 }] = await db.any(`SELECT
      "${objs.database1.private_schema_name}".encrypt_field_pgp_get(refresh_token, account_id::text)
       FROM
       "${objs.database1.private_schema_name}".tesla_secrets`);

    expect(val2).toMatchSnapshot();

    const jobs1 = await db.any(`SELECT * FROM "${objs.schemas.jobs}".jobs`);
    console.log(jobs1);

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.enduser1.id,
      'jwt.claims.group_ids': psqlIds([objs.enduser1.id])
    });

    await api.private.update(
      'tesla_secrets',
      {
        access_token: 'cheers',
        refresh_token: 'halo'
      },
      {
        account_id: teslaAcccount.id
      }
    );

    db.setContext({
      role: 'postgres'
    });

    const [{ encrypt_field_pgp_get: val3 }] = await db.any(`SELECT
      "${objs.database1.private_schema_name}".encrypt_field_pgp_get(refresh_token, account_id::text)
       FROM
       "${objs.database1.private_schema_name}".tesla_secrets`);

    expect(val3).toMatchSnapshot();

    const jobs2 = await db.any(`SELECT * FROM "${objs.schemas.jobs}".jobs`);
    console.log(jobs2);

    // cars

    conn.setContext({
      role: 'authenticated',
      'jwt.claims.user_id': objs.enduser1.id,
      'jwt.claims.group_ids': psqlIds([objs.enduser1.id])
    });

    const teslaVehicle = await api.public.insertOne('tesla_vehicles', {
      account_id: teslaAcccount.id,
      tesla_id: 'myteslaid'
    });

    console.log(teslaVehicle);

    const rec1 = await api.private.insertOne('tesla_records', {
      account_id: teslaAcccount.id,
      vehicle_id: teslaVehicle.id,
      battery_level: 2.11
    });

    console.log(rec1);
  })();
});
