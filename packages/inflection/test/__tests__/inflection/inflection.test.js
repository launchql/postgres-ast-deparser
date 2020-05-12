import cases from 'jest-in-case';
import {
  getConnections,
  closeConnections,
} from '../../utils';

let db, conn;

describe('inflection', () => {
  beforeAll(async () => {
    ({ db, conn } = await getConnections());
  });
  afterAll(async () => {
    await closeConnections({ db, conn });
  });
  cases('slugify', async opts => {
    const { pg_slugify } = await db.one(
      'SELECT * FROM inflection.pg_slugify($1, $2)',
      [opts.name, opts.allowUnicode]
    );
    expect(pg_slugify).toBe(opts.result);
  }, [
    { name: 'Hello, World!', allowUnicode: false, result: 'Hello_World' },
    { name: 'Héllø, Wørld!', allowUnicode: false, result: 'Hello_World' },
    { name: 'spam & eggs', allowUnicode: false, result: 'spam_eggs' },
    { name: 'spam & ıçüş', allowUnicode: true, result: 'spam_ıçüş' },
    { name: 'foo ıç bar', allowUnicode: true, result: 'foo_ıç_bar' },
    { name: '    foo ıç bar', allowUnicode: true, result: 'foo_ıç_bar' },
    { name: '你好', allowUnicode: true, result: '你好' },
    { name: 'message_properties', allowUnicode: false, result: 'message_properties' },
    { name: 'MessageProperties', allowUnicode: false, result: 'MessageProperties' },
    { name: 'WebACL', allowUnicode: false, result: 'WebAcl' },
  ]);
  cases('underscore', async opts => {
    const { underscore } = await db.one(
      'SELECT * FROM inflection.underscore( $1 )',
      [opts.name]
    );
    expect(underscore).toBe(opts.result);
  }, [
    { name: 'MessageProperties', result: 'message_properties' },
    { name: 'messageProperties', result: 'message_properties' },
    { name: 'message_properties', result: 'message_properties' },
    { name: 'MP', result: 'mp' },
    { name: 'WebACL', result: 'web_acl' },
  ]);
  cases('pascal', async opts => {
    const { pascal } = await db.one(
      'SELECT * FROM inflection.pascal( $1 )',
      [opts.name]
    );
    expect(pascal).toBe(opts.result);
  }, [
    { name: 'MessageProperties', result: 'MessageProperties' },
    { name: 'message_properties', result: 'MessageProperties' },
    { name: 'messageProperties', result: 'MessageProperties' },
    { name: 'MP', result: 'Mp' },
    { name: 'WebAcl', result: 'WebAcl' },
    { name: 'WebACL', result: 'WebAcl' },
    { name: 'web_acl', result: 'WebAcl' },
    { name: 'web acl', result: 'WebAcl' },
    { name: 'Web Acl', result: 'WebAcl' },
    { name: 'Web ACL', result: 'WebAcl' },
  ]);
  cases('camel', async opts => {
    const { camel } = await db.one(
      'SELECT * FROM inflection.camel( $1 )',
      [opts.name]
    );
    expect(camel).toBe(opts.result);
  }, [
    { name: 'MessageProperties', result: 'messageProperties' },
    { name: 'message_properties', result: 'messageProperties' },
    { name: 'messageProperties', result: 'messageProperties' },
    { name: 'MP', result: 'mp' },
    { name: 'webAcl', result: 'webAcl' },
    { name: 'WebACL', result: 'webAcl' },
    { name: 'web_acl', result: 'webAcl' },
    { name: 'web acl', result: 'webAcl' },
    { name: 'Web Acl', result: 'webAcl' },
    { name: 'Web ACL', result: 'webAcl' },
  ]);
  cases('no_consecutive_caps', async opts => {
    const { no_consecutive_caps } = await db.one(
      'SELECT * FROM inflection.no_consecutive_caps( $1 )',
      [opts.name]
    );
    expect(no_consecutive_caps).toBe(opts.result);
  }, [
    { name: 'MP', result: 'Mp' },
    { name: 'Web_ACL', result: 'Web_Acl' },
  ]);
  cases('plural', async opts => {
    const { plural } = await db.one(
      'SELECT * FROM inflection.plural( $1 )',
      [opts.name]
    );
    expect(plural).toBe(opts.result);
  }, [
    { name: 'user_login', result: 'user_logins' },
    { name: 'user Login', result: 'user Logins' },
    { name: 'user_logins', result: 'user_logins' },
    { name: 'user Logins', result: 'user Logins' },
    { name: 'children', result: 'children' },
    { name: 'child', result: 'children' },
    { name: 'man', result: 'men' },
    { name: 'men', result: 'men' },
  ]);
  cases('singular', async opts => {
    const { singular } = await db.one(
      'SELECT * FROM inflection.singular( $1 )',
      [opts.name]
    );
    expect(singular).toBe(opts.result);
  }, [
    { name: 'user_logins', result: 'user_login' },
    { name: 'user Logins', result: 'user Login' },
    { name: 'user_login', result: 'user_login' },
    { name: 'user Login', result: 'user Login' },
    { name: 'children', result: 'child' },
    { name: 'child', result: 'child' },
    { name: 'man', result: 'man' },
    { name: 'men', result: 'man' },
  ]);
});