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
              roletype: 3
            }
          }
        ],
        qual: {
          SubLink: {
            subLinkType: 4,
            subselect: {
              SelectStmt: {
                targetList: [
                  {
                    ResTarget: {
                      val: {
                        A_Expr: {
                          kind: 1,
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
                      jointype: 0,
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
                          boolop: 0,
                          args: [
                            {
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
                op: 0
              }
            }
          }
        }
      }
    },
    stmt_len: 417
  }
};
