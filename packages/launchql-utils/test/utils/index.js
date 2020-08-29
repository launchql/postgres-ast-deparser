import * as testing from '@launchql/db-testing';

jasmine.DEFAULT_TIMEOUT_INTERVAL = 30000;

export const getConnection = async () => {
  return await testing.getTestConnection();
};

export const closeConnection = async (db) => {
  await testing.closeConnection(db);
};

export const getConnections = async () => {
  return await testing.getConnections();
};

export const closeConnections = async ({ db, conn }) => {
  await testing.closeConnections({ db, conn });
};
