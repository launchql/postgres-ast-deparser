import { getConnections } from '../../utils';

let db, teardown;
const objs = {
  tables: {}
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint();
});
afterAll(async () => {
  try {
    //try catch here allows us to see the sql parsing issues!
    await db.rollback();
    await db.commit();
    await teardown();
  } catch (e) {
    // noop
  }
});

it('select policy (using)', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.create_policy(
                v_policy_name := 'mypolicy'::text,
                v_schema_name := 'myschema'::text,
                v_table_name := 'mytable'::text,
                v_roles := '{app_user, auth_user}'::text[],
                v_qual := ast.bool_expr(
                    v_boolop := 1,
                    v_args := to_jsonb(
                        ARRAY[
                            ast.a_expr(
                                v_kind := 0,
                                v_name := to_jsonb(ARRAY[
                                    ast.string('=')
                                ]),
                                v_lexpr := ast.func_call(
                                    v_funcname := to_jsonb(ARRAY[
                                        ast.string('roles_public'),
                                        ast.string('current_role_id')
                                    ])
                                ),
                                v_rexpr := ast.column_ref(
                                    v_fields := to_jsonb(ARRAY[
                                        ast.string('role_id')
                                    ])
                                )
                            ),
                            ast.func_call(
                                v_funcname := to_jsonb(ARRAY[
                                    ast.string('permissions_private'),
                                    ast.string('permitted_on_role')
                                ]),
                                v_args := to_jsonb(ARRAY[
                                    ast.column_ref(
                                        v_fields := to_jsonb(ARRAY[
                                            ast.string('group_id')
                                        ])
                                    )
                                ])
                            )
                        ]
                    )
                ),
                v_cmd_name := 'SELECT'::text,
                v_permissive := false::boolean
            )
         );`
  );
  expect(result).toMatchSnapshot();
});

it('insert policy (with_check)', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.create_policy(
                v_policy_name := 'mypolicy'::text,
                v_schema_name := 'myschema'::text,
                v_table_name := 'mytable'::text,
                v_roles := '{app_user, auth_user}'::text[],
                v_with_check := ast.bool_expr(
                    v_boolop := 1,
                    v_args := to_jsonb(
                        ARRAY[
                            ast.a_expr(
                                v_kind := 0,
                                v_name := to_jsonb(ARRAY[
                                    ast.string('=')
                                ]),
                                v_lexpr := ast.func_call(
                                    v_funcname := to_jsonb(ARRAY[
                                        ast.string('roles_public'),
                                        ast.string('current_role_id')
                                    ])
                                ),
                                v_rexpr := ast.column_ref(
                                    v_fields := to_jsonb(ARRAY[
                                        ast.string('role_id')
                                    ])
                                )
                            ),
                            ast.func_call(
                                v_funcname := to_jsonb(ARRAY[
                                    ast.string('permissions_private'),
                                    ast.string('permitted_on_role')
                                ]),
                                v_args := to_jsonb(ARRAY[
                                    ast.column_ref(
                                        v_fields := to_jsonb(ARRAY[
                                            ast.string('group_id')
                                        ])
                                    )
                                ])
                            )
                        ]
                    )
                ),
                v_cmd_name := 'INSERT'::text,
                -- v_with_check := to_jsonb(),
                v_permissive := true::boolean
            )
         );`
  );
  expect(result).toMatchSnapshot();
});

it('table_grant update', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.table_grant(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_priv_name := 'update',
                v_cols := ARRAY['col1', 'column-asdf'],
                v_is_grant := true,
                v_role_name := 'authenticated'
                )
         );`
  );
  expect(result).toMatchSnapshot();
});

it('table_grant select', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.table_grant(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_priv_name := 'select',
                v_cols := ARRAY['col1', 'column-asdf'],
                v_is_grant := true,
                v_role_name := 'authenticated'
                )
         );`
  );
  expect(result).toMatchSnapshot();
});

it('table_grant revoke select', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.table_grant(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_priv_name := 'select',
                v_cols := ARRAY['col1', 'column-asdf'],
                v_is_grant := false,
                v_role_name := 'authenticated'
                )
         );`
  );
  expect(result).toMatchSnapshot();
});

it('noCalls', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
            ast_helpers.table_grant(
                v_schema_name := 'myschema',
                v_table_name := 'mytable',
                v_priv_name := 'select',
                v_is_grant := true,
                v_role_name := 'authenticated'
                )
         );`
  );
  expect(result).toMatchSnapshot();
});
