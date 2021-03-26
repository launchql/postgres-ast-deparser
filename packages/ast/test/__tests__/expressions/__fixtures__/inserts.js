export const inserts = [
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              schemaname: 'objects',
              relname: 'object',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'val'
              }
            },
            {
              ResTarget: {
                name: 'active'
              }
            },
            {
              ResTarget: {
                name: 'hash'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'name'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'val'
                        }
                      }
                    }
                  },
                  {
                    TypeCast: {
                      arg: {
                        A_Const: {
                          val: {
                            String: {
                              str: 't'
                            }
                          }
                        }
                      },
                      typeName: {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'pg_catalog'
                              }
                            },
                            {
                              String: {
                                str: 'bool'
                              }
                            }
                          ],
                          typemod: -1
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'abcdefg'
                        }
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'name'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'val'
                        }
                      }
                    }
                  },
                  {
                    TypeCast: {
                      arg: {
                        A_Const: {
                          val: {
                            String: {
                              str: 't'
                            }
                          }
                        }
                      },
                      typeName: {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'pg_catalog'
                              }
                            },
                            {
                              String: {
                                str: 'bool'
                              }
                            }
                          ],
                          typemod: -1
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'abcdefg'
                        }
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'name'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'val'
                        }
                      }
                    }
                  },
                  {
                    TypeCast: {
                      arg: {
                        A_Const: {
                          val: {
                            String: {
                              str: 't'
                            }
                          }
                        }
                      },
                      typeName: {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'pg_catalog'
                              }
                            },
                            {
                              String: {
                                str: 'bool'
                              }
                            }
                          ],
                          typemod: -1
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'abcdefg'
                        }
                      }
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 180
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              schemaname: 'yo',
              relname: 'table',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'project_id'
              }
            },
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'field_name'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'v_obj_key_id'
                          }
                        }
                      ]
                    }
                  },
                  {
                    TypeCast: {
                      arg: {
                        ColumnRef: {
                          fields: [
                            {
                              String: {
                                str: 'v_secret_name'
                              }
                            }
                          ]
                        }
                      },
                      typeName: {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'bytea'
                              }
                            }
                          ],
                          typemod: -1
                        }
                      }
                    }
                  },
                  {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'v_secret_value'
                          }
                        }
                      ]
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 'ONCONFLICT_UPDATE',
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    },
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    }
                  ]
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'field_name',
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'excluded'
                            }
                          },
                          {
                            String: {
                              str: 'field_name'
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
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 206
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              schemaname: 'yo',
              relname: 'table',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'project_id'
              }
            },
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'field_name'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'v_obj_key_id'
                          }
                        }
                      ]
                    }
                  },
                  {
                    TypeCast: {
                      arg: {
                        ColumnRef: {
                          fields: [
                            {
                              String: {
                                str: 'v_secret_name'
                              }
                            }
                          ]
                        }
                      },
                      typeName: {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'bytea'
                              }
                            }
                          ],
                          typemod: -1
                        }
                      }
                    }
                  },
                  {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'v_secret_value'
                          }
                        }
                      ]
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 'ONCONFLICT_UPDATE',
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    },
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    }
                  ]
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'field_name',
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'excluded'
                            }
                          },
                          {
                            String: {
                              str: 'field_name'
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
                            str: 'prop'
                          }
                        }
                      ]
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 1
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 223
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              schemaname: 'yo',
              relname: 'table',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'project_id'
              }
            },
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'field_name'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'v_obj_key_id'
                          }
                        }
                      ]
                    }
                  },
                  {
                    TypeCast: {
                      arg: {
                        ColumnRef: {
                          fields: [
                            {
                              String: {
                                str: 'v_secret_name'
                              }
                            }
                          ]
                        }
                      },
                      typeName: {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'bytea'
                              }
                            }
                          ],
                          typemod: -1
                        }
                      }
                    }
                  },
                  {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'v_secret_value'
                          }
                        }
                      ]
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 'ONCONFLICT_NOTHING',
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    },
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    }
                  ]
                }
              }
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 161
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'customers',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'email'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'Microsoft'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      }
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 'ONCONFLICT_NOTHING',
              infer: {
                InferClause: {
                  conname: 'customers_name_key'
                }
              }
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 150
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'customers',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'email'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'Microsoft'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      }
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 'ONCONFLICT_UPDATE',
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    }
                  ]
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'email',
                    val: {
                      A_Expr: {
                        kind: 'AEXPR_OP',
                        name: [
                          {
                            String: {
                              str: '||'
                            }
                          }
                        ],
                        lexpr: {
                          A_Expr: {
                            kind: 'AEXPR_OP',
                            name: [
                              {
                                String: {
                                  str: '||'
                                }
                              }
                            ],
                            lexpr: {
                              ColumnRef: {
                                fields: [
                                  {
                                    String: {
                                      str: 'excluded'
                                    }
                                  },
                                  {
                                    String: {
                                      str: 'email'
                                    }
                                  }
                                ]
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  String: {
                                    str: ';'
                                  }
                                }
                              }
                            }
                          }
                        },
                        rexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'customers'
                                }
                              },
                              {
                                String: {
                                  str: 'email'
                                }
                              }
                            ]
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 181
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'customers',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'email'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'Microsoft'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      }
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 'ONCONFLICT_UPDATE',
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    }
                  ]
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'email',
                    val: {
                      A_Expr: {
                        kind: 'AEXPR_OP',
                        name: [
                          {
                            String: {
                              str: '||'
                            }
                          }
                        ],
                        lexpr: {
                          A_Expr: {
                            kind: 'AEXPR_OP',
                            name: [
                              {
                                String: {
                                  str: '||'
                                }
                              }
                            ],
                            lexpr: {
                              ColumnRef: {
                                fields: [
                                  {
                                    String: {
                                      str: 'excluded'
                                    }
                                  },
                                  {
                                    String: {
                                      str: 'email'
                                    }
                                  }
                                ]
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  String: {
                                    str: ';'
                                  }
                                }
                              }
                            }
                          }
                        },
                        rexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'customers'
                                }
                              },
                              {
                                String: {
                                  str: 'email'
                                }
                              }
                            ]
                          }
                        }
                      }
                    }
                  }
                },
                {
                  ResTarget: {
                    name: 'level',
                    val: {
                      A_Expr: {
                        kind: 'AEXPR_OP',
                        name: [
                          {
                            String: {
                              str: '+'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'customers'
                                }
                              },
                              {
                                String: {
                                  str: 'level'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 1
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                {
                  ResTarget: {
                    name: 'other',
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'excluded'
                            }
                          },
                          {
                            String: {
                              str: 'other'
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
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 259
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'customers',
              inh: true,
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name'
              }
            },
            {
              ResTarget: {
                name: 'email'
              }
            }
          ],
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'Microsoft'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      }
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 'ONCONFLICT_UPDATE',
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'id',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    },
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 'SORTBY_DEFAULT',
                        nulls_ordering: 'SORTBY_NULLS_DEFAULT'
                      }
                    }
                  ]
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'email',
                    val: {
                      A_Expr: {
                        kind: 'AEXPR_OP',
                        name: [
                          {
                            String: {
                              str: '||'
                            }
                          }
                        ],
                        lexpr: {
                          A_Expr: {
                            kind: 'AEXPR_OP',
                            name: [
                              {
                                String: {
                                  str: '||'
                                }
                              }
                            ],
                            lexpr: {
                              ColumnRef: {
                                fields: [
                                  {
                                    String: {
                                      str: 'excluded'
                                    }
                                  },
                                  {
                                    String: {
                                      str: 'email'
                                    }
                                  }
                                ]
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  String: {
                                    str: ';'
                                  }
                                }
                              }
                            }
                          }
                        },
                        rexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'customers'
                                }
                              },
                              {
                                String: {
                                  str: 'email'
                                }
                              }
                            ]
                          }
                        }
                      }
                    }
                  }
                },
                {
                  ResTarget: {
                    name: 'level',
                    val: {
                      A_Expr: {
                        kind: 'AEXPR_OP',
                        name: [
                          {
                            String: {
                              str: '+'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'customers'
                                }
                              },
                              {
                                String: {
                                  str: 'level'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 1
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                {
                  ResTarget: {
                    name: 'other',
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'excluded'
                            }
                          },
                          {
                            String: {
                              str: 'other'
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
          returningList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        A_Star: {}
                      }
                    ]
                  }
                }
              }
            }
          ],
          override: 'OVERRIDING_NOT_SET'
        }
      },
      stmt_len: 285
    }
  }
];
