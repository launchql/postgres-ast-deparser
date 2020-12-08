import { getConnections } from '../../utils';
import { initDatabase } from '../../utils/helpers';
import { snapshot } from '../../utils/snaps';
import { Schema } from 'pg-query-string';

const schema = new Schema('collections_public');
const table = schema.table('table', {
  id: 'uuid'
});
const field = schema.table('field', {
  id: 'uuid'
});
const unique_constraint = schema.table('unique_constraint', {
  id: 'uuid',
  field_ids: 'uuid[]'
});
const foreign_key_constraint = schema.table('foreign_key_constraint', {
  id: 'uuid',
  field_ids: 'uuid[]',
  ref_field_ids: 'uuid[]'
});
const primary_key_constraint = schema.table('primary_key_constraint', {
  id: 'uuid',
  field_ids: 'uuid[]'
});
const check_constraint = schema.table('check_constraint', {
  id: 'uuid',
  field_ids: 'uuid[]',
  expr: 'jsonb'
});

let db, conn, dbs, teardown;
const objs = {};

beforeAll(async () => {
  ({ db, conn, teardown } = await getConnections());
  dbs = db.helper('collections_public');
});
afterAll(async () => {
  try {
    await teardown();
  } catch (e) {
    console.log(e);
  }
});
beforeEach(async () => {
  await db.beforeEach();
  await initDatabase({ objs, dbs });
});
afterEach(async () => {
  await db.afterEach();
});

let user, post, userIdField, postIdField, usernameField, authorIdField;

const getOne = async (query) => {
  return await db.one(query.text, query.values);
};
const get = async (query) => {
  return await db.any(query.text, query.values);
};

beforeEach(async () => {
  user = await getOne(
    table.insert({
      database_id: objs.database1.id,
      schema_id: objs.database1.schemas.public.id,
      name: 'user'
    })
  );
  post = await getOne(
    table.insert({
      database_id: objs.database1.id,
      schema_id: objs.database1.schemas.public.id,
      name: 'post'
    })
  );
  userIdField = await getOne(
    field.insert({
      table_id: user.id,
      name: 'id',
      type: 'uuid',
      is_required: true,
      default_value: 'uuid_generate_v4 ()'
    })
  );
  postIdField = await getOne(
    field.insert({
      table_id: post.id,
      name: 'id',
      type: 'uuid',
      is_required: true,
      default_value: 'uuid_generate_v4 ()'
    })
  );
  usernameField = await getOne(
    field.insert({
      table_id: user.id,
      name: 'username',
      type: 'text'
    })
  );
  authorIdField = await getOne(
    field.insert({
      table_id: post.id,
      name: 'author_id',
      type: 'uuid'
    })
  );
});

it('can create a unique constraint', async () => {
  const uniq = await getOne(
    unique_constraint.insert({
      table_id: user.id,
      field_ids: [usernameField.id]
    })
  );
  expect(snapshot(uniq)).toMatchSnapshot();
});

it('can create a primary key constraint', async () => {
  const primary = await getOne(
    primary_key_constraint.insert({
      table_id: user.id,
      field_ids: [userIdField.id]
    })
  );
  expect(snapshot(primary)).toMatchSnapshot();
});

it('can create a foreign key constraint with no action', async () => {
  const primary = await getOne(
    primary_key_constraint.insert({
      table_id: user.id,
      field_ids: [userIdField.id]
    })
  );
  const foreign = await getOne(
    foreign_key_constraint.insert({
      table_id: post.id,
      field_ids: [authorIdField.id],
      ref_table_id: user.id,
      ref_field_ids: [userIdField.id],
      delete_action: 'a',
      update_action: 'a'
    })
  );
  expect(snapshot(foreign)).toMatchSnapshot();
});
it('can create a foreign key constraint with action options', async () => {
  const primary = await getOne(
    primary_key_constraint.insert({
      table_id: user.id,
      field_ids: [userIdField.id]
    })
  );
  const foreign = await getOne(
    foreign_key_constraint.insert({
      table_id: post.id,
      field_ids: [authorIdField.id],
      ref_table_id: user.id,
      ref_field_ids: [userIdField.id],
      delete_action: 'c',
      update_action: 'r'
    })
  );
  expect(snapshot(foreign)).toMatchSnapshot();
});
it('can create a multi primary key constraint', async () => {
  const primary = await getOne(
    primary_key_constraint.insert({
      table_id: post.id,
      field_ids: [postIdField.id, authorIdField.id]
    })
  );
  expect(snapshot(primary)).toMatchSnapshot();
});
it('can create a multi unique constraint', async () => {
  const uniq = await getOne(
    unique_constraint.insert({
      table_id: post.id,
      field_ids: [postIdField.id, authorIdField.id]
    })
  );
  expect(snapshot(uniq)).toMatchSnapshot();
});
it('can create a multi foreign constraint', async () => {
  const anotherField = await getOne(
    field.insert({
      table_id: post.id,
      name: 'reference',
      type: 'text'
    })
  );
  await getOne(
    primary_key_constraint.insert({
      table_id: user.id,
      field_ids: [userIdField.id, usernameField.id]
    })
  );
  const foreign = await getOne(
    foreign_key_constraint.insert({
      table_id: post.id,
      field_ids: [postIdField.id, anotherField.id],
      ref_table_id: user.id,
      ref_field_ids: [userIdField.id, usernameField.id],
      delete_action: 'c',
      update_action: 'r'
    })
  );
  expect(snapshot(foreign)).toMatchSnapshot();
});
