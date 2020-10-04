export const policies = [
  {
    RawStmt: {
      stmt: {
        CreatePolicyStmt: {
          policy_name: 'authenticated_can_delete_on_user_secrets',
          table: {
            RangeVar: {
              schemaname: 'dashboard_private',
              relname: 'user_secrets',
              inh: true,
              relpersistence: 'p',
              location: 61
            }
          },
          cmd_name: 'delete',
          permissive: true,
          roles: [
            {
              RoleSpec: {
                roletype: 0,
                rolename: 'authenticated',
                location: 128
              }
            }
          ],
          qual: {
            A_Expr: {
              kind: 0,
              name: [
                {
                  String: {
                    str: '='
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'user_id'
                      }
                    }
                  ],
                  location: 157
                }
              },
              rexpr: {
                FuncCall: {
                  funcname: [
                    {
                      String: {
                        str: 'dashboard_public'
                      }
                    },
                    {
                      String: {
                        str: 'get_current_user_id'
                      }
                    }
                  ],
                  location: 167
                }
              },
              location: 165
            }
          }
        }
      },
      stmt_len: 211
    }
  }
];
