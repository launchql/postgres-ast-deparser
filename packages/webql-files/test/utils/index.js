import * as dotenv from 'dotenv';
import * as testing from 'skitch-testing';

import { user as fakeUser } from './faker';

jasmine.DEFAULT_TIMEOUT_INTERVAL = 30000;
dotenv.config({ path: '.env' });

export const getConnection = async () => {
  return await testing.getTestConnection();
};

export const closeConnection = async db => {
  await testing.closeConnection(db);
};

export const getConnections = async () => {
  return await testing.getConnections();
};

export const closeConnections = async ({ db, conn }) => {
  await testing.closeConnections({ db, conn });
};


export const createUser = async (db, userInfo) => {
  if (!userInfo) {
    userInfo = await fakeUser();
  }

  const {
    username,
    display_name,
    email,
    email_is_verified,
    avatar_url,
    password
  } = userInfo;

  db.setContext({
    role: 'anonymous'
  });

  const user = await db.one(
    'SELECT * FROM roles_private.register_user($1, $2, $3, $4, $5, $6)',
    [username, display_name, email, email_is_verified, avatar_url, password]
  );

  db.setContext({});

  // store for tests
  user.email = userInfo.email;
  user.password = userInfo.password;
  return user;
};
