export async function getstatus(db, author, proj) {
  const head = await db.any(
    `
    SELECT id, path, data FROM checkout_private.ref_head_tree
      WHERE project_id=$1
      AND ref_id=$2
      AND author_id=$3
    ORDER BY dir_depth(path)
  `,
    [proj.id, proj.ref_id, author.id]
  );
  const stage = await db.any(
    `
    SELECT id, path, data FROM checkout_private.staging_index
      WHERE project_id=$1
      AND ref_id=$2
      AND author_id=$3
    ORDER BY dir_depth(path)
  `,
    [proj.id, proj.ref_id, author.id]
  );
  const worktree = await db.any(
    `
    SELECT id, path, data FROM checkout_private.worktree
      WHERE project_id=$1
      AND ref_id=$2
      AND author_id=$3
    ORDER BY dir_depth(path)
  `,
    [proj.id, proj.ref_id, author.id]
  );

  return {
    head,
    stage,
    worktree
  };
}
