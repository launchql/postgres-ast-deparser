export default {
  RawStmt: {
    stmt: {
      CreatePolicyStmt: {
        policy_name: 'delete_the_thing',
        table: {
          RangeVar: {
            schemaname: 'users',
            relname: 'user',
            inh: true,
            relpersistence: 'p'
          }
        },
        cmd_name: 'delete',
        permissive: true,
        roles: [
          {
            RoleSpec: {
              roletype: 'ROLESPEC_PUBLIC'
            }
          }
        ],
        qual: {
          SubLink: {
            subLinkType: 'EXPR_SUBLINK',
            subselect: {
              SelectStmt: {
                targetList: [
                  {
                    ResTarget: {
                      val: {
                        A_Expr: {
                          kind: 'AEXPR_OP_ANY',
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
                                    str: 'p'
                                  }
                                },
                                {
                                  String: {
                                    str: 'owned_table_key'
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
                                    str: 'current_role_fn_schema'
                                  }
                                },
                                {
                                  String: {
                                    str: 'current_group_ids_function'
                                  }
                                }
                              ]
                            }
                          }
                        }
                      }
                    }
                  }
                ],
                fromClause: [
                  {
                    JoinExpr: {
                      jointype: 'JOIN_INNER',
                      larg: {
                        RangeVar: {
                          schemaname: 'object_schema',
                          relname: 'object_table',
                          inh: true,
                          relpersistence: 'p',
                          alias: {
                            Alias: {
                              aliasname: 'c'
                            }
                          }
                        }
                      },
                      rarg: {
                        RangeVar: {
                          schemaname: 'owned_schema',
                          relname: 'owned_table',
                          inh: true,
                          relpersistence: 'p',
                          alias: {
                            Alias: {
                              aliasname: 'p'
                            }
                          }
                        }
                      },
                      quals: {
                        BoolExpr: {
                          boolop: 'AND_EXPR',
                          args: [
                            {
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
                                          str: 'p'
                                        }
                                      },
                                      {
                                        String: {
                                          str: 'owned_table_ref_key'
                                        }
                                      }
                                    ]
                                  }
                                },
                                rexpr: {
                                  ColumnRef: {
                                    fields: [
                                      {
                                        String: {
                                          str: 'c'
                                        }
                                      },
                                      {
                                        String: {
                                          str: 'object_table_owned_key'
                                        }
                                      }
                                    ]
                                  }
                                }
                              }
                            },
                            {
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
                                          str: 'p'
                                        }
                                      },
                                      {
                                        String: {
                                          str: 'owned_table_ref_key'
                                        }
                                      }
                                    ]
                                  }
                                },
                                rexpr: {
                                  ColumnRef: {
                                    fields: [
                                      {
                                        String: {
                                          str: 'this_owned_key'
                                        }
                                      }
                                    ]
                                  }
                                }
                              }
                            }
                          ]
                        }
                      }
                    }
                  }
                ],
                whereClause: {
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
                              str: 'c'
                            }
                          },
                          {
                            String: {
                              str: 'object_table_ref_key'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'this_object_key'
                            }
                          }
                        ]
                      }
                    }
                  }
                },
                op: 'SETOP_NONE'
              }
            }
          }
        }
      }
    },
    stmt_len: 417
  }
};
