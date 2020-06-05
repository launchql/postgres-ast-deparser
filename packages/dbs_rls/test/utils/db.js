function range(start, end) {
  var foo = [];
  for (var i = start; i <= end; i++) {
    foo.push(i);
  }
  return foo;
}

const getParameter = (N, i, castsArray) => {
  if (castsArray[i]) {
    return '$' + N + '::' + castsArray[i];
  }
  return '$' + N;
};

const P = (values, castVals) => {
  const array = range(1, values.length);
  // makes ($1, $2, $3, $4)
  const that = array.map((a, i) => getParameter(a, i, castVals)  ).join(', ');
  return `(${that})`;
};

export const getInsertStmt = (name, vars, casts={}) => {
  const keys = Object.keys(vars);
  const castVals = keys.map(k=>casts[k]);
  const values = Object.values(vars);
  // console.log( `INSERT INTO ${name} (${keys.join(',')}) VALUES ${P(values, castVals)} RETURNING *`);
  return `INSERT INTO ${name} (${keys.join(',')}) VALUES ${P(values, castVals)} RETURNING *`;
};

export const getInsert = (name, vars, casts) => {
  const values = Object.values(vars);
  return [getInsertStmt(name, vars, casts), values];
};

export const wrapConn = (conn) => {
  conn.insertOne = async (name, vars, casts) => {
    return await conn.one(...getInsert(name, vars, casts));
  };
};
