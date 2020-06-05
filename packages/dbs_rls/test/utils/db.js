function range(start, end) {
  var foo = [];
  for (var i = start; i <= end; i++) {
    foo.push(i);
  }
  return foo;
}

const P = (values) => {
  const array = range(1, values.length);
  // makes ($1, $2, $3, $4)
  const that = array.map(a => '$' + a).join(', ');
  return `(${that})`;
};

export const getInsertStmt = (name, vars) => {
  const keys = Object.keys(vars);
  const values = Object.values(vars);
  return `INSERT INTO ${name} (${keys.join(',')}) VALUES ${P(values)} RETURNING *`;
};

export const getInsert = (name, vars) => {
  const values = Object.values(vars);
  return [getInsertStmt(name, vars), values];
};

export const wrapConn = (conn) => {
  conn.insertOne = async (name, vars) => {
    return await conn.one(...getInsert(name, vars));
  };
};
