export const selects = [
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '<'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 10
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 169
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'stringu1'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '<'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ]
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 179
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'stringu1'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '>'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'stringu1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ]
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 181
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '>'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ]
              }
            },
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ]
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 207
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '>'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ]
              }
            },
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ]
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 207
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '<'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ]
              }
            },
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ]
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 205
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek'
                        }
                      },
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '<'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ]
              }
            },
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ]
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 205
    }
  },
  {
    RawStmt: {
      stmt: {
        VacuumStmt: {
          options: 2,
          relation: {
            RangeVar: {
              relname: 'onek2',
              inh: true,
              relpersistence: 'p'
            }
          }
        }
      },
      stmt_len: 270
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_SET_VALUE',
          name: 'enable_seqscan',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                }
              }
            }
          ]
        }
      },
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_SET_VALUE',
          name: 'enable_bitmapscan',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                }
              }
            }
          ]
        }
      },
      stmt_len: 29
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_SET_VALUE',
          name: 'enable_sort',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                }
              }
            }
          ]
        }
      },
      stmt_len: 23
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek2'
                        }
                      },
                      {
                        A_Star: {}
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '<'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek2'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 10
                    }
                  }
                }
              }
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 125
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek2'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek2'
                        }
                      },
                      {
                        String: {
                          str: 'stringu1'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '<'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek2'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  }
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ]
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 185
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek2'
                        }
                      },
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'onek2'
                        }
                      },
                      {
                        String: {
                          str: 'stringu1'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 'AEXPR_OP',
              name: [
                {
                  String: {
                    str: '>'
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'onek2'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  }
                }
              }
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 156
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_RESET',
          name: 'enable_seqscan'
        }
      },
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_RESET',
          name: 'enable_bitmapscan'
        }
      },
      stmt_len: 24
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_RESET',
          name: 'enable_sort'
        }
      },
      stmt_len: 18
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          intoClause: {
            IntoClause: {
              rel: {
                RangeVar: {
                  relname: 'tmp',
                  inh: true,
                  relpersistence: 'p'
                }
              },
              onCommit: 0
            }
          },
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'two'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'stringu1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'ten'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'string4'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 68
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'p'
                        }
                      },
                      {
                        String: {
                          str: 'name'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'p'
                        }
                      },
                      {
                        String: {
                          str: 'age'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'person',
                inh: true,
                relpersistence: 'p',
                alias: {
                  Alias: {
                    aliasname: 'p'
                  }
                }
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 344
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'p'
                        }
                      },
                      {
                        String: {
                          str: 'name'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'p'
                        }
                      },
                      {
                        String: {
                          str: 'age'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'person',
                inh: true,
                relpersistence: 'p',
                alias: {
                  Alias: {
                    aliasname: 'p'
                  }
                }
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'age'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_USING',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT',
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ]
              }
            },
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'name'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 332
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'foo'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeSubselect: {
                subquery: {
                  SelectStmt: {
                    targetList: [
                      {
                        ResTarget: {
                          val: {
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
                    ],
                    op: 'SETOP_NONE'
                  }
                },
                alias: {
                  Alias: {
                    aliasname: 'foo'
                  }
                }
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 107
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'foo'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeSubselect: {
                subquery: {
                  SelectStmt: {
                    targetList: [
                      {
                        ResTarget: {
                          val: {
                            A_Const: {
                              val: {
                                Null: {}
                              }
                            }
                          }
                        }
                      }
                    ],
                    op: 'SETOP_NONE'
                  }
                },
                alias: {
                  Alias: {
                    aliasname: 'foo'
                  }
                }
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 37
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'foo'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeSubselect: {
                subquery: {
                  SelectStmt: {
                    targetList: [
                      {
                        ResTarget: {
                          val: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'xyzzy'
                                }
                              }
                            }
                          }
                        }
                      },
                      {
                        ResTarget: {
                          val: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 1
                                }
                              }
                            }
                          }
                        }
                      },
                      {
                        ResTarget: {
                          val: {
                            A_Const: {
                              val: {
                                Null: {}
                              }
                            }
                          }
                        }
                      }
                    ],
                    op: 'SETOP_NONE'
                  }
                },
                alias: {
                  Alias: {
                    aliasname: 'foo'
                  }
                }
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 47
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            },
            {
              RangeSubselect: {
                subquery: {
                  SelectStmt: {
                    valuesLists: [
                      [
                        {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 147
                              }
                            }
                          }
                        },
                        {
                          A_Const: {
                            val: {
                              String: {
                                str: 'RFAAAA'
                              }
                            }
                          }
                        }
                      ],
                      [
                        {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 931
                              }
                            }
                          }
                        },
                        {
                          A_Const: {
                            val: {
                              String: {
                                str: 'VJAAAA'
                              }
                            }
                          }
                        }
                      ]
                    ],
                    op: 'SETOP_NONE'
                  }
                },
                alias: {
                  Alias: {
                    aliasname: 'v',
                    colnames: [
                      {
                        String: {
                          str: 'i'
                        }
                      },
                      {
                        String: {
                          str: 'j'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          whereClause: {
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
                              str: 'onek'
                            }
                          },
                          {
                            String: {
                              str: 'unique1'
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
                              str: 'v'
                            }
                          },
                          {
                            String: {
                              str: 'i'
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
                              str: 'onek'
                            }
                          },
                          {
                            String: {
                              str: 'stringu1'
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
                              str: 'v'
                            }
                          },
                          {
                            String: {
                              str: 'j'
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
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 154
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            },
            {
              RangeSubselect: {
                subquery: {
                  SelectStmt: {
                    valuesLists: [
                      [
                        {
                          SubLink: {
                            subLinkType: 'EXPR_SUBLINK',
                            subselect: {
                              SelectStmt: {
                                targetList: [
                                  {
                                    ResTarget: {
                                      val: {
                                        ColumnRef: {
                                          fields: [
                                            {
                                              String: {
                                                str: 'i'
                                              }
                                            }
                                          ]
                                        }
                                      }
                                    }
                                  }
                                ],
                                fromClause: [
                                  {
                                    RangeSubselect: {
                                      subquery: {
                                        SelectStmt: {
                                          valuesLists: [
                                            [
                                              {
                                                A_Const: {
                                                  val: {
                                                    Integer: {
                                                      ival: 10000
                                                    }
                                                  }
                                                }
                                              }
                                            ],
                                            [
                                              {
                                                A_Const: {
                                                  val: {
                                                    Integer: {
                                                      ival: 2
                                                    }
                                                  }
                                                }
                                              }
                                            ],
                                            [
                                              {
                                                A_Const: {
                                                  val: {
                                                    Integer: {
                                                      ival: 389
                                                    }
                                                  }
                                                }
                                              }
                                            ],
                                            [
                                              {
                                                A_Const: {
                                                  val: {
                                                    Integer: {
                                                      ival: 1000
                                                    }
                                                  }
                                                }
                                              }
                                            ],
                                            [
                                              {
                                                A_Const: {
                                                  val: {
                                                    Integer: {
                                                      ival: 2000
                                                    }
                                                  }
                                                }
                                              }
                                            ],
                                            [
                                              {
                                                SubLink: {
                                                  subLinkType: 'EXPR_SUBLINK',
                                                  subselect: {
                                                    SelectStmt: {
                                                      targetList: [
                                                        {
                                                          ResTarget: {
                                                            val: {
                                                              A_Const: {
                                                                val: {
                                                                  Integer: {
                                                                    ival: 10029
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                      ],
                                                      op: 'SETOP_NONE'
                                                    }
                                                  }
                                                }
                                              }
                                            ]
                                          ],
                                          op: 'SETOP_NONE'
                                        }
                                      },
                                      alias: {
                                        Alias: {
                                          aliasname: 'foo',
                                          colnames: [
                                            {
                                              String: {
                                                str: 'i'
                                              }
                                            }
                                          ]
                                        }
                                      }
                                    }
                                  }
                                ],
                                sortClause: [
                                  {
                                    SortBy: {
                                      node: {
                                        ColumnRef: {
                                          fields: [
                                            {
                                              String: {
                                                str: 'i'
                                              }
                                            }
                                          ]
                                        }
                                      },
                                      sortby_dir: 'SORTBY_ASC',
                                      sortby_nulls: 'SORTBY_NULLS_DEFAULT'
                                    }
                                  }
                                ],
                                limitCount: {
                                  A_Const: {
                                    val: {
                                      Integer: {
                                        ival: 1
                                      }
                                    }
                                  }
                                },
                                op: 'SETOP_NONE'
                              }
                            }
                          }
                        }
                      ]
                    ],
                    op: 'SETOP_NONE'
                  }
                },
                alias: {
                  Alias: {
                    aliasname: 'bar',
                    colnames: [
                      {
                        String: {
                          str: 'i'
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
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
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
                        str: 'bar'
                      }
                    },
                    {
                      String: {
                        str: 'i'
                      }
                    }
                  ]
                }
              }
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 249
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            SubLink: {
              subLinkType: 'ANY_SUBLINK',
              testexpr: {
                RowExpr: {
                  args: [
                    {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique1'
                            }
                          }
                        ]
                      }
                    },
                    {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'ten'
                            }
                          }
                        ]
                      }
                    }
                  ],
                  row_format: 'COERCE_IMPLICIT_CAST'
                }
              },
              subselect: {
                SelectStmt: {
                  valuesLists: [
                    [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 1
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 1
                            }
                          }
                        }
                      }
                    ],
                    [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 20
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 0
                            }
                          }
                        }
                      }
                    ],
                    [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 99
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 9
                            }
                          }
                        }
                      }
                    ],
                    [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 17
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 99
                            }
                          }
                        }
                      }
                    ]
                  ],
                  op: 'SETOP_NONE'
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 136
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          valuesLists: [
            [
              {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 1
                    }
                  }
                }
              },
              {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 2
                    }
                  }
                }
              }
            ],
            [
              {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 3
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
                        str: '+'
                      }
                    }
                  ],
                  lexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 4
                        }
                      }
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 4
                        }
                      }
                    }
                  }
                }
              }
            ],
            [
              {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 7
                    }
                  }
                }
              },
              {
                A_Const: {
                  val: {
                    Float: {
                      str: '77.7'
                    }
                  }
                }
              }
            ]
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 'FUNC_PARAM_IN'
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          op: 'SETOP_UNION',
          all: true,
          larg: {
            SelectStmt: {
              op: 'SETOP_UNION',
              all: true,
              larg: {
                SelectStmt: {
                  valuesLists: [
                    [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 1
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 2
                            }
                          }
                        }
                      }
                    ],
                    [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 3
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
                                str: '+'
                              }
                            }
                          ],
                          lexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 4
                                }
                              }
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 4
                                }
                              }
                            }
                          }
                        }
                      }
                    ],
                    [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 7
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Float: {
                              str: '77.7'
                            }
                          }
                        }
                      }
                    ]
                  ],
                  op: 'SETOP_NONE'
                }
              },
              rarg: {
                SelectStmt: {
                  targetList: [
                    {
                      ResTarget: {
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
                              A_Const: {
                                val: {
                                  Integer: {
                                    ival: 2
                                  }
                                }
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  Integer: {
                                    ival: 2
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
                        val: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 57
                              }
                            }
                          }
                        }
                      }
                    }
                  ],
                  op: 'SETOP_NONE'
                }
              }
            }
          },
          rarg: {
            SelectStmt: {
              targetList: [
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
              fromClause: [
                {
                  RangeVar: {
                    relname: 'int8_tbl',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              op: 'SETOP_NONE'
            }
          }
        }
      },
      stmt_len: 83
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'foo',
              inh: true,
              relpersistence: 't'
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'f1',
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
                          str: 'int4'
                        }
                      }
                    ],
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'foo',
              inh: true,
              relpersistence: 'p'
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 42
                        }
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 3
                        }
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 10
                        }
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 7
                        }
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      }
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 1
                        }
                      }
                    }
                  }
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          override: 0
        }
      },
      stmt_len: 60
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 31
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_ASC',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 34
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_FIRST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 56
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_LAST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 46
    }
  },
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'fooi',
          relation: {
            RangeVar: {
              relname: 'foo',
              inh: true,
              relpersistence: 'p'
            }
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                name: 'f1',
                ordering: 0,
                nulls_ordering: 0
              }
            }
          ]
        }
      },
      stmt_len: 74
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_SET_VALUE',
          name: 'enable_sort',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'false'
                  }
                }
              }
            }
          ]
        }
      },
      stmt_len: 24
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 31
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_FIRST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 42
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_LAST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 46
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            [
              {
                String: {
                  str: 'fooi'
                }
              }
            ]
          ],
          removeType: 'OBJECT_INDEX',
          behavior: 'DROP_RESTRICT'
        }
      },
      stmt_len: 17
    }
  },
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'fooi',
          relation: {
            RangeVar: {
              relname: 'foo',
              inh: true,
              relpersistence: 'p'
            }
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                name: 'f1',
                ordering: 2,
                nulls_ordering: 0
              }
            }
          ]
        }
      },
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 31
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_FIRST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 42
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_LAST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 46
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            [
              {
                String: {
                  str: 'fooi'
                }
              }
            ]
          ],
          removeType: 'OBJECT_INDEX',
          behavior: 'DROP_RESTRICT'
        }
      },
      stmt_len: 17
    }
  },
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'fooi',
          relation: {
            RangeVar: {
              relname: 'foo',
              inh: true,
              relpersistence: 'p'
            }
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                name: 'f1',
                ordering: 2,
                nulls_ordering: 2
              }
            }
          ]
        }
      },
      stmt_len: 46
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 31
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_FIRST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 42
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'f1'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DESC',
                sortby_nulls: 'SORTBY_NULLS_LAST'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 46
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
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
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            }
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
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'ATAAAA'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 170
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        }
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
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'ATAAAA'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 63
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            }
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
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'ATAAAA'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 89
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique2'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        }
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
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'ATAAAA'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 69
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
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
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            }
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
                              str: '<'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 143
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        }
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
                          str: '<'
                        }
                      }
                    ],
                    lexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 58
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            }
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
                              str: '<'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 'DEFELEM_UNSPEC'
              }
            }
          ]
        }
      },
      stmt_len: 84
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique2'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        }
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
                          str: '<'
                        }
                      }
                    ],
                    lexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            }
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
                              str: '<'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              lockingClause: [
                {
                  LockingClause: {
                    strength: 4,
                    waitPolicy: 0
                  }
                }
              ],
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 147
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique2'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        }
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
                          str: '<'
                        }
                      }
                    ],
                    lexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          lockingClause: [
            {
              LockingClause: {
                strength: 4,
                waitPolicy: 0
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 75
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            }
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
                              str: '<'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'C'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 119
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique2'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        }
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
                          str: '<'
                        }
                      }
                    ],
                    lexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'C'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_SET_VALUE',
          name: 'enable_indexscan',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                }
              }
            }
          ]
        }
      },
      stmt_len: 107
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            }
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
                              str: '<'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 84
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique2'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        }
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
                          str: '<'
                        }
                      }
                    ],
                    lexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 'VAR_RESET',
          name: 'enable_indexscan'
        }
      },
      stmt_len: 23
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique1'
                            }
                          }
                        ]
                      }
                    }
                  }
                },
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
                BoolExpr: {
                  boolop: 'AND_EXPR',
                  args: [
                    {
                      BoolExpr: {
                        boolop: 'OR_EXPR',
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
                                        str: 'unique2'
                                      }
                                    }
                                  ]
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 11
                                    }
                                  }
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
                                        str: 'unique1'
                                      }
                                    }
                                  ]
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 0
                                    }
                                  }
                                }
                              }
                            }
                          }
                        ]
                      }
                    },
                    {
                      A_Expr: {
                        kind: 'AEXPR_OP',
                        name: [
                          {
                            String: {
                              str: '<'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'stringu1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 143
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique2'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            BoolExpr: {
              boolop: 'AND_EXPR',
              args: [
                {
                  BoolExpr: {
                    boolop: 'OR_EXPR',
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
                                    str: 'unique2'
                                  }
                                }
                              ]
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 11
                                }
                              }
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
                                    str: 'unique1'
                                  }
                                }
                              ]
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 0
                                }
                              }
                            }
                          }
                        }
                      }
                    ]
                  }
                },
                {
                  A_Expr: {
                    kind: 'AEXPR_OP',
                    name: [
                      {
                        String: {
                          str: '<'
                        }
                      }
                    ],
                    lexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'stringu1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 92
    }
  },
  {
    RawStmt: {
      stmt: {
        ExplainStmt: {
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique1'
                            }
                          }
                        ]
                      }
                    }
                  }
                },
                {
                  ResTarget: {
                    val: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'unique2'
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              whereClause: {
                BoolExpr: {
                  boolop: 'OR_EXPR',
                  args: [
                    {
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
                                        str: 'unique2'
                                      }
                                    }
                                  ]
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 11
                                    }
                                  }
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
                                    str: '<'
                                  }
                                }
                              ],
                              lexpr: {
                                ColumnRef: {
                                  fields: [
                                    {
                                      String: {
                                        str: 'stringu1'
                                      }
                                    }
                                  ]
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    String: {
                                      str: 'B'
                                    }
                                  }
                                }
                              }
                            }
                          }
                        ]
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
                                  str: 'unique1'
                                }
                              }
                            ]
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 0
                              }
                            }
                          }
                        }
                      }
                    }
                  ]
                }
              },
              op: 'SETOP_NONE'
            }
          },
          options: [
            {
              DefElem: {
                defname: 'costs',
                arg: {
                  String: {
                    str: 'off'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 112
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique1'
                        }
                      }
                    ]
                  }
                }
              }
            },
            {
              ResTarget: {
                val: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'unique2'
                        }
                      }
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            BoolExpr: {
              boolop: 'OR_EXPR',
              args: [
                {
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
                                    str: 'unique2'
                                  }
                                }
                              ]
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 11
                                }
                              }
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
                                str: '<'
                              }
                            }
                          ],
                          lexpr: {
                            ColumnRef: {
                              fields: [
                                {
                                  String: {
                                    str: 'stringu1'
                                  }
                                }
                              ]
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'B'
                                }
                              }
                            }
                          }
                        }
                      }
                    ]
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
                              str: 'unique1'
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 0
                          }
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 92
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                name: 'x',
                val: {
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
          ],
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'x'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 161
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateFunctionStmt: {
          funcname: [
            {
              String: {
                str: 'sillysrf'
              }
            }
          ],
          parameters: [
            {
              FunctionParameter: {
                argType: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'pg_catalog'
                        }
                      },
                      {
                        String: {
                          str: 'int4'
                        }
                      }
                    ],
                    typemod: -1
                  }
                },
                mode: 'FUNC_PARAM_IN'
              }
            }
          ],
          returnType: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'pg_catalog'
                  }
                },
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              setof: true,
              typemod: -1
            }
          },
          options: [
            {
              DefElem: {
                defname: 'as',
                arg: [
                  {
                    String: {
                      str: 'values (1),(10),(2),($1)'
                    }
                  }
                ],
                defaction: 0
              }
            },
            {
              DefElem: {
                defname: 'language',
                arg: {
                  String: {
                    str: 'sql'
                  }
                },
                defaction: 0
              }
            },
            {
              DefElem: {
                defname: 'volatility',
                arg: {
                  String: {
                    str: 'immutable'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
      stmt_len: 152
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'sillysrf'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 42
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
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 21
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'sillysrf'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: -1
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
          sortClause: [
            {
              SortBy: {
                node: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 1
                      }
                    }
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 31
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              ObjectWithArgs: {
                objname: [
                  {
                    String: {
                      str: 'sillysrf'
                    }
                  }
                ],
                objargs: [
                  {
                    TypeName: {
                      names: [
                        {
                          String: {
                            str: 'pg_catalog'
                          }
                        },
                        {
                          String: {
                            str: 'int4'
                          }
                        }
                      ],
                      typemod: -1
                    }
                  }
                ]
              }
            }
          ],
          removeType: 'OBJECT_FUNCTION',
          behavior: 'DROP_RESTRICT'
        }
      },
      stmt_len: 29
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeSubselect: {
                subquery: {
                  SelectStmt: {
                    valuesLists: [
                      [
                        {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 2
                              }
                            }
                          }
                        }
                      ],
                      [
                        {
                          A_Const: {
                            val: {
                              Null: {}
                            }
                          }
                        }
                      ],
                      [
                        {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 1
                              }
                            }
                          }
                        }
                      ]
                    ],
                    op: 'SETOP_NONE'
                  }
                },
                alias: {
                  Alias: {
                    aliasname: 'v',
                    colnames: [
                      {
                        String: {
                          str: 'k'
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
                        str: 'k'
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
                        str: 'k'
                      }
                    }
                  ]
                }
              }
            }
          },
          sortClause: [
            {
              SortBy: {
                node: {
                  ColumnRef: {
                    fields: [
                      {
                        String: {
                          str: 'k'
                        }
                      }
                    ]
                  }
                },
                sortby_dir: 'SORTBY_DEFAULT',
                sortby_nulls: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 162
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
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
          fromClause: [
            {
              RangeSubselect: {
                subquery: {
                  SelectStmt: {
                    valuesLists: [
                      [
                        {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 2
                              }
                            }
                          }
                        }
                      ],
                      [
                        {
                          A_Const: {
                            val: {
                              Null: {}
                            }
                          }
                        }
                      ],
                      [
                        {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 1
                              }
                            }
                          }
                        }
                      ]
                    ],
                    op: 'SETOP_NONE'
                  }
                },
                alias: {
                  Alias: {
                    aliasname: 'v',
                    colnames: [
                      {
                        String: {
                          str: 'k'
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
                        str: 'k'
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
                        str: 'k'
                      }
                    }
                  ]
                }
              }
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 55
    }
  }
];
