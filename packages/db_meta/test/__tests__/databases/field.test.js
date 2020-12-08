import { getConnections } from '../../utils';
import { snap } from '../../utils/snaps';
import { initDatabase } from '../../utils/helpers';

let db, dbs, custom, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  dbs = db.helper('collections_public');

  // NOTE: POTENTIALLY YOU WILL NEED TO MOVE THIS AND BELOW CODE INTO beforeEach
  // honeslty not sure why it's not casuing issues... I'm guessing it cleans up all the created tables, etc.,
  // during the rollbacks... so it works!?!
});

beforeEach(async () => {
  await db.beforeEach();
  await initDatabase({ objs, dbs });
  custom = {
    public: db.helper(objs.database1.schema_name),
    private: db.helper(objs.database1.private_schema_name)
  };
  objs.tables.customer = await dbs.insertOne('table', {
    database_id: objs.database1.id,
    schema_id: objs.database1.schemas.public.id,
    name: 'customers'
  });
});

afterEach(async () => {
  await db.afterEach();
});

afterAll(async () => {
  await teardown();
});

it('can create a field', async () => {
  await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'id',
    type: 'uuid',
    is_required: true,
    default_value: 'uuid_generate_v4 ()'
  });

  const nameField = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'name',
    type: 'text'
  });

  expect(nameField).toBeTruthy();
  expect(nameField.id).toBeTruthy();

  await db.any(
    `INSERT INTO "${objs.database1.schema_name}".customers (name) VALUES ('dan'), ('jobs')`
  );
  const customers = await db.any(
    `SELECT id, name FROM "${objs.database1.schema_name}".customers`
  );
  expect(customers).toBeTruthy();
  expect(customers.length).toBe(2);
});

it('can create an array field', async () => {
  await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'id',
    type: 'uuid',
    is_required: true,
    default_value: 'uuid_generate_v4 ()'
  });

  const nameField = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'name',
    type: 'text'
  });

  const tagsField = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'tags',
    type: 'text[]'
  });

  const catsField = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'cats',
    type: 'text [ ]'
  });

  expect(nameField).toBeTruthy();
  expect(nameField.id).toBeTruthy();
  snap(tagsField);
  snap(catsField);

  await db.insertOne(
    `"${objs.database1.schema_name}".customers`,
    {
      name: ['dude', 'yo', 'hi']
    },
    { name: 'text[]' }
  );

  await db.insertOne(
    `"${objs.database1.schema_name}".customers`,
    {
      name: ['james', 'c', 'christiansen']
    },
    { name: 'text[]' }
  );

  const customers = await db.any(
    `SELECT name FROM "${objs.database1.schema_name}".customers`
  );
  expect(customers).toMatchSnapshot();
  expect(customers).toBeTruthy();
  expect(customers.length).toBe(2);
});

it('can rename fields', async () => {
  await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'id',
    type: 'uuid',
    is_required: true,
    default_value: 'uuid_generate_v4 ()'
  });

  const referral = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'referral',
    type: 'uuid'
  });

  expect(referral).toBeTruthy();
  expect(referral.id).toBeTruthy();

  await custom.public.insertOne('customers', {
    referral: '929cde1e-6b8b-424c-ade9-99949a0c0212'
  });

  await dbs.update(
    'field',
    {
      name: 'referral_id'
    },
    {
      id: referral.id
    }
  );

  await custom.public.insertOne('customers', {
    referral_id: '911cde1e-6b8b-424c-ade9-99949a0c0212'
  });
});

it('can change type of fields', async () => {
  await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'id',
    type: 'uuid',
    is_required: true,
    default_value: 'uuid_generate_v4 ()'
  });

  const referral = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'referral',
    type: 'uuid'
  });

  expect(referral).toBeTruthy();
  expect(referral.id).toBeTruthy();

  await custom.public.insertOne('customers', {
    referral: '929cde1e-6b8b-424c-ade9-99949a0c0212'
  });

  await dbs.update(
    'field',
    {
      type: 'text'
    },
    {
      id: referral.id
    }
  );

  await custom.public.insertOne('customers', {
    referral: 'jones'
  });

  await custom.public.update(
    'customers',
    {
      referral: '929cde1e-6b8b-424c-ade9-99949a0c0201'
    },
    {
      referral: 'jones'
    }
  );

  await dbs.update(
    'field',
    {
      type: 'uuid'
    },
    {
      id: referral.id
    }
  );
});

it('can add tags to fields', async () => {
  await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'id',
    type: 'uuid',
    is_required: true,
    default_value: 'uuid_generate_v4 ()'
  });

  const image = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    description: 'Customer Profile Image',
    name: 'image',
    type: 'text'
  });

  expect(image).toBeTruthy();
  expect(image.id).toBeTruthy();

  const { get_column_smart_comment: commentBefore } = await db.one(
    `
          SELECT * FROM db_utils.get_column_smart_comment(
            $1,
            $2,
            $3
          )
          `,
    [objs.database1.schema_name, 'customers', 'image']
  );

  expect(commentBefore).toMatchSnapshot();

  await custom.public.insertOne('customers', {
    image: 'path/to/my.jpg'
  });

  await dbs.update(
    'field',
    {
      smart_tags: {
        attachment: true,
        mimetypes: ['image/jpg', 'image/png']
      },
      description: 'Customer Profile Image'
    },
    {
      id: image.id
    }
  );

  const { get_column_smart_comment: comment } = await db.one(
    `
          SELECT * FROM db_utils.get_column_smart_comment(
            $1,
            $2,
            $3
          )
          `,
    [objs.database1.schema_name, 'customers', 'image']
  );

  expect(comment).toMatchSnapshot();

  await dbs.update(
    'field',
    {
      smart_tags: {},
      description: null
    },
    {
      id: image.id
    }
  );

  const { get_column_smart_comment: commentAfter } = await db.one(
    `
          SELECT * FROM db_utils.get_column_smart_comment(
            $1,
            $2,
            $3
          )
          `,
    [objs.database1.schema_name, 'customers', 'image']
  );

  expect(commentAfter == null).toBe(true);
});

it('can delete fields', async () => {
  await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'id',
    type: 'uuid',
    is_required: true,
    default_value: 'uuid_generate_v4 ()'
  });

  await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'name',
    type: 'text'
  });

  const referral = await dbs.insertOne('field', {
    table_id: objs.tables.customer.id,
    name: 'referral',
    type: 'uuid'
  });

  expect(referral).toBeTruthy();
  expect(referral.id).toBeTruthy();

  await custom.public.insertOne('customers', {
    referral: '929cde1e-6b8b-424c-ade9-99949a0c0212'
  });

  await dbs.delete('field', {
    id: referral.id
  });

  const fields = await dbs.select('field', ['name', 'type'], {
    table_id: objs.tables.customer.id
  });

  expect(fields).toMatchSnapshot();

  const customers = await custom.public.select('customers', ['*']);

  expect(customers[0]).toBeTruthy();
  expect(customers[0].id).toBeTruthy();
  expect(customers[0].referral).toBeFalsy();
});

describe('naming conventions', () => {
  it('field names are snake_case', async () => {
    await dbs.insertOne('field', {
      table_id: objs.tables.customer.id,
      name: 'id',
      type: 'uuid',
      is_required: true,
      default_value: 'uuid_generate_v4()'
    });

    await dbs.insertOne('field', {
      table_id: objs.tables.customer.id,
      name: 'firstName',
      type: 'text'
    });

    await dbs.insertOne('field', {
      table_id: objs.tables.customer.id,
      name: 'LastName',
      type: 'text'
    });

    await db.any(
      `INSERT INTO "${objs.database1.schema_name}".customers(first_name, last_name) VALUES ('dan', 'lynch'), ('steve', 'jobs')`
    );
    const customers = await db.any(
      `SELECT id, first_name, last_name FROM "${objs.database1.schema_name}".customers`
    );
    expect(customers).toBeTruthy();
    expect(customers.length).toBe(2);
  });
});
describe('hidden fields', () => {
  xit('field names are snake_case', async () => {
    await db.any(
      `insert into collections_public.field 
              (table_id, name, type, is_required, default_value) 
              values 
              ($1, $2, $3, $4, $5) RETURNING *`,
      [objs.tables.customer.id, 'id', 'uuid', true, 'uuid_generate_v4 ()']
    );
    await db.any(
      'insert into collections_public.field (table_id, name, type) values ($1, $2, $3)',
      [objs.tables.customer.id, 'firstName', 'text']
    );
    await db.any(
      'insert into collections_public.field (table_id, name, type) values ($1, $2, $3)',
      [objs.tables.customer.id, 'LastName', 'text']
    );
    await db.any(
      'insert into collections_public.field (table_id, name, type, is_hidden) values ($1, $2, $3, $4)',
      [objs.tables.customer.id, 'password', 'text', true]
    );

    await db.any(
      `INSERT INTO "${objs.database1.schema_name}".customers(first_name, last_name) VALUES ('dan', 'lynch'), ('steve', 'jobs')`
    );
    const customers = await db.any(
      `SELECT id, first_name, last_name FROM "${objs.database1.schema_name}".customers`
    );
    const { get_column_smart_comment } = await db.one(
      `
            SELECT * FROM db_utils.get_column_smart_comment(
              $1,
              $2,
              $3
            )
            `,
      [objs.database1.schema_name, 'customers', 'password']
    );
    expect(get_column_smart_comment).toEqual('@omit');
    expect(customers).toBeTruthy();
    expect(customers.length).toBe(2);
  });
});
