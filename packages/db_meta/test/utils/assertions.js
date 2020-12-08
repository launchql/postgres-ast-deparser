export const assertFailureWithTx = async ({
  savepoint = `error${Date.now()}`,
  db,
  try: tryFn,
  assert: assertFn
}) => {
  let failed = false;
  await db.savepoint(savepoint);
  try {
    await tryFn();
  } catch (e) {
    failed = true;
    await assertFn(e);
  }
  expect(failed).toBe(true);
  await db.rollback(savepoint);
};

export const assertFailure = async ({ try: tryFn, assert: assertFn }) => {
  let failed = false;
  try {
    await tryFn();
  } catch (e) {
    failed = true;
    await assertFn(e);
  }
  expect(failed).toBe(true);
};
