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
              relpersistence: 'p'
            }
          },
          cmd_name: 'delete',
          permissive: true,
          roles: [
            {
              RoleSpec: {
                roletype: 'ROLESPEC_CSTRING',
                rolename: 'authenticated'
              }
            }
          ],
          qual: {
            A_Expr: {
              kind: 'AEXPR_OP',
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
                  ]
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
                  ]
                }
              }
            }
          }
        }
      },
      stmt_len: 211
    }
  }
];

export const current_groups_ast = {
  FuncCall: {
    funcname: [
      {
        String: {
          str: 'memberships_private'
        }
      },
      {
        String: {
          str: 'org_memberships_perm_ids'
        }
      }
    ],
    args: [
      {
        A_Const: {
          val: {
            String: {
              str: '10000011111'
            }
          }
        }
      }
    ]
  }
};

export const current_groups_ast2 = {
  FuncCall: {
    funcname: [
      {
        String: {
          str: 'array_append'
        }
      }
    ],
    args: [
      {
        CoalesceExpr: {
          args: [
            {
              FuncCall: {
                funcname: [
                  {
                    String: {
                      str: 'memberships_private'
                    }
                  },
                  {
                    String: {
                      str: 'org_memberships_perm_ids'
                    }
                  }
                ],
                args: [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: '10000011111'
                        }
                      }
                    }
                  }
                ]
              }
            },
            {
              TypeCast: {
                arg: {
                  A_ArrayExpr: {}
                },
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'uuid'
                        }
                      }
                    ],
                    typemod: -1,
                    arrayBounds: [
                      {
                        Integer: {
                          ival: -1
                        }
                      }
                    ]
                  }
                }
              }
            }
          ]
        }
      },
      {
        FuncCall: {
          funcname: [
            {
              String: {
                str: 'jwt_public'
              }
            },
            {
              String: {
                str: 'current_user_id'
              }
            }
          ]
        }
      }
    ]
  }
};

export const current_user_ast = {
  FuncCall: {
    funcname: [
      {
        String: {
          str: 'super_secret'
        }
      },
      {
        String: {
          str: 'current_user_id'
        }
      }
    ],
    args: []
  }
};
