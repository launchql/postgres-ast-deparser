An asynchronous job queue schema for ACID compliant job creation through triggers/functions/etc.

Original author is Benjie Gillam https://gist.github.com/benjie/839740697f5a1c46ee8da98a1efac218

# setup

`worker.js` is the node.js worker. Copy that file into your node app, and add a `tasks.js` file. Job workers are asynchronous functions of the form:

```js
 async function ({ debug, pgPool }, job) {
   // worker code here
 }
```
