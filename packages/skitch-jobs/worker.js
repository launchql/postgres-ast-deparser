/*
 * A sample worker for Benjie's Postgres job queue.
 *
 * Requires Node v8.6+ (or Babel)
 *
 * Author: Benjie Gillam <code@benjiegillam.com>
 * License: MIT
 * URL: https://gist.github.com/benjie/839740697f5a1c46ee8da98a1efac218
 * Donations: https://www.paypal.me/benjie
 */

// //////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////
// CONFIGURATION

/*
 * tasks: should contain an object, the keys of which are task identifiers and the values of which are job workers.
 * Job workers are asyncronous functions of the form:
 *
 * async function ({ debug, pgPool }, job) {
 *   // worker code here
 * }
 */
const tasks = require("./tasks");

/*
 * idleDelay: This is how long to wait between polling for jobs.
 *
 * Note: this does NOT need to be short, because we use LISTEN/NOTIFY to be
 * notified when new jobs are added - this is just used in the case where
 * LISTEN/NOTIFY fails for whatever reason.
 */
const idleDelay = 15000;

// END OF CONFIGURATION
// //////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////

/* eslint-disable no-console */

const pg = require("pg");
const debugFactory = require("debug");

const debug = debugFactory("worker");
debug("Booting worker");

const supportedTaskNames = Object.keys(tasks);
const workerId = `worker-${Math.random()}`;

let doNextTimer = null;

const pgPoolConfig = {
  connectionString: process.env.DATABASE_URL,
};

const requiredDirectly = require.main === module;

const pgPool = requiredDirectly ? new pg.Pool(pgPoolConfig) : null;

function fakePgPool(client) {
  // Only really intended for usage during testing!
  const fakeQuery = (...args) => client.query(...args);
  return {
    connect: () => ({
      query: fakeQuery,
      release: () => {},
    }),
    query: fakeQuery,
  };
}

const doNext = async (client, continuous = true) => {
  if (!continuous && process.env.NODE_ENV !== "test") {
    throw new Error(
      "Continuous should always be true except in a test environment"
    );
  }
  clearTimeout(doNextTimer);
  doNextTimer = null;
  try {
    const {
      rows: [job],
    } = await client.query("SELECT * FROM app_jobs.get_job($1, $2);", [
      workerId,
      supportedTaskNames,
    ]);
    if (!job || !job.id) {
      if (continuous) {
        doNextTimer = setTimeout(() => doNext(client, continuous), idleDelay);
      }
      return null;
    }
    debug(`Found task ${job.id} (${job.task_identifier})`);
    const start = process.hrtime();
    const worker = tasks[job.task_identifier];
    if (!worker) {
      throw new Error("Unsupported task");
    }
    const ctx = {
      debug: debugFactory(`worker:${job.task_identifier}`),
      pgPool: continuous ? pgPool : fakePgPool(client),
      // You can give your workers more context here if you like.
    };
    let err;
    try {
      await worker(ctx, job);
    } catch (error) {
      err = error;
    }
    const durationRaw = process.hrtime(start);
    const duration = ((durationRaw[0] * 1e9 + durationRaw[1]) / 1e6).toFixed(2);
    try {
      if (err) {
        console.error(
          `Failed task ${job.id} (${job.task_identifier}) with error ${err.message} (${duration}ms)`,
          { err, stack: err.stack }
        );
        console.error(err.stack);
        await client.query("SELECT * FROM app_jobs.fail_job($1, $2, $3);", [
          workerId,
          job.id,
          err.message,
        ]);
      } else {
        console.log(
          `Completed task ${job.id} (${job.task_identifier}) with success (${duration}ms)`
        );
        await client.query("SELECT * FROM app_jobs.complete_job($1, $2);", [
          workerId,
          job.id,
        ]);
      }
    } catch (fatalError) {
      const when = err ? `after failure '${err.message}'` : "after success";
      console.error(
        `Failed to release job '${job.id}' ${when}; committing seppuku`
      );
      console.error(fatalError);
      if (continuous) {
        process.exit(1);
      }
    }
    return doNext(client, continuous);
  } catch (err) {
    if (continuous) {
      debug(`ERROR! ${err.message}`);
      doNextTimer = setTimeout(() => doNext(client, continuous), idleDelay);
    } else {
      throw err;
    }
  }
};

function makeNewListener() {
  const listenForChanges = (err, client, release) => {
    if (err) {
      console.error("Error connecting with notify listener", err);
      // Try again in 5 seconds
      setTimeout(makeNewListener, 5000);
      return;
    }
    client.on("notification", _msg => {
      if (doNextTimer) {
        // Must be idle, do something!
        doNext(client);
      }
    });
    client.query('LISTEN "jobs:insert"');
    client.on("error", e => {
      console.error("Error with database notify listener", e);
      release();
      makeNewListener();
    });
    console.log("Worker connected and looking for jobs...");
    doNext(client);
  };
  pgPool.connect(listenForChanges);
}

if (requiredDirectly) {
  if (process.argv.slice(2).includes("--once")) {
    (async function() {
      let exitStatus = 0;
      let client;
      try {
        const client = await pgPool.connect();
        await doNext(client, false);
      } catch (e) {
        console.error(e);
        exitStatus = 1;
      } finally {
        if (client) {
          await client.release();
        }
      }
      pgPool.end();
      process.exit(exitStatus);
    })();
  } else {
    makeNewListener();
  }
} else {
  exports.runAllJobs = client => doNext(client, false);
}
