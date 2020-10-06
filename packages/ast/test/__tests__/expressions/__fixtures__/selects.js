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
                    ],
                    location: 106
                  }
                },
                location: 106
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 113
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 127
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 10
                    }
                  },
                  location: 142
                }
              },
              location: 140
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
                    ],
                    location: 157
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
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
                    ],
                    location: 257
                  }
                },
                location: 257
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
                    ],
                    location: 271
                  }
                },
                location: 271
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 290
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 304
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  },
                  location: 319
                }
              },
              location: 317
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
                    ],
                    location: 334
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ],
                location: 348
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 170,
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
                    ],
                    location: 437
                  }
                },
                location: 437
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
                    ],
                    location: 451
                  }
                },
                location: 451
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 470
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 484
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  },
                  location: 499
                }
              },
              location: 497
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
                    ],
                    location: 515
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ],
                location: 530
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 350,
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
                    ],
                    location: 630
                  }
                },
                location: 630
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
                    ],
                    location: 644
                  }
                },
                location: 644
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 662
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 676
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  },
                  location: 691
                }
              },
              location: 689
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
                    ],
                    location: 707
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ],
                location: 721
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
                    ],
                    location: 724
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ],
                location: 738
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 532,
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
                    ],
                    location: 838
                  }
                },
                location: 838
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
                    ],
                    location: 852
                  }
                },
                location: 852
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 870
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 884
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  },
                  location: 899
                }
              },
              location: 897
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
                    ],
                    location: 915
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ],
                location: 929
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
                    ],
                    location: 932
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ],
                location: 946
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 740,
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
                    ],
                    location: 1045
                  }
                },
                location: 1045
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
                    ],
                    location: 1059
                  }
                },
                location: 1059
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 1077
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 1091
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  },
                  location: 1106
                }
              },
              location: 1104
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
                    ],
                    location: 1121
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ],
                location: 1135
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
                    ],
                    location: 1138
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ],
                location: 1152
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 948,
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
                    ],
                    location: 1251
                  }
                },
                location: 1251
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
                    ],
                    location: 1265
                  }
                },
                location: 1265
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 1283
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 1297
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  },
                  location: 1312
                }
              },
              location: 1310
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
                    ],
                    location: 1327
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '<'
                    }
                  }
                ],
                location: 1341
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
                    ],
                    location: 1344
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ],
                location: 1358
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 1154,
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
              relpersistence: 'p',
              location: 1625
            }
          }
        }
      },
      stmt_location: 1360,
      stmt_len: 270
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 0,
          name: 'enable_seqscan',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                },
                location: 1655
              }
            }
          ]
        }
      },
      stmt_location: 1631,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 0,
          name: 'enable_bitmapscan',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                },
                location: 1685
              }
            }
          ]
        }
      },
      stmt_location: 1659,
      stmt_len: 29
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 0,
          name: 'enable_sort',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                },
                location: 1709
              }
            }
          ]
        }
      },
      stmt_location: 1689,
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
                    ],
                    location: 1795
                  }
                },
                location: 1795
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 1808
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 1820
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 10
                    }
                  },
                  location: 1836
                }
              },
              location: 1834
            }
          },
          op: 0
        }
      },
      stmt_location: 1713,
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
                    ],
                    location: 1926
                  }
                },
                location: 1926
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
                    ],
                    location: 1941
                  }
                },
                location: 1941
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 1961
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 1977
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 20
                    }
                  },
                  location: 1993
                }
              },
              location: 1991
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
                    ],
                    location: 2009
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ],
                location: 2023
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 1839,
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
                    ],
                    location: 2112
                  }
                },
                location: 2112
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
                    ],
                    location: 2127
                  }
                },
                location: 2127
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 2147
              }
            }
          ],
          whereClause: {
            A_Expr: {
              kind: 0,
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
                  ],
                  location: 2162
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 980
                    }
                  },
                  location: 2178
                }
              },
              location: 2176
            }
          },
          op: 0
        }
      },
      stmt_location: 2025,
      stmt_len: 156
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 4,
          name: 'enable_seqscan'
        }
      },
      stmt_location: 2182,
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 4,
          name: 'enable_bitmapscan'
        }
      },
      stmt_location: 2205,
      stmt_len: 24
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 4,
          name: 'enable_sort'
        }
      },
      stmt_location: 2230,
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
                  relpersistence: 'p',
                  location: 2301
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
                    ],
                    location: 2259
                  }
                },
                location: 2259
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
                    ],
                    location: 2264
                  }
                },
                location: 2264
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
                    ],
                    location: 2274
                  }
                },
                location: 2274
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
                    ],
                    location: 2279
                  }
                },
                location: 2279
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 2313
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2249,
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
                    ],
                    location: 2634
                  }
                },
                location: 2634
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
                    ],
                    location: 2642
                  }
                },
                location: 2642
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
                },
                location: 2653
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2318,
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
                    ],
                    location: 2940
                  }
                },
                location: 2940
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
                    ],
                    location: 2948
                  }
                },
                location: 2948
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
                },
                location: 2959
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
                    ],
                    location: 2978
                  }
                },
                sortby_dir: 3,
                sortby_nulls: 0,
                useOp: [
                  {
                    String: {
                      str: '>'
                    }
                  }
                ],
                location: 2988
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
                    ],
                    location: 2991
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2663,
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
                    ],
                    location: 3077
                  }
                },
                location: 3077
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
                              },
                              location: 3094
                            }
                          },
                          location: 3094
                        }
                      }
                    ],
                    op: 0
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
          op: 0
        }
      },
      stmt_location: 2996,
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
                    ],
                    location: 3112
                  }
                },
                location: 3112
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
                              },
                              location: 3129
                            }
                          },
                          location: 3129
                        }
                      }
                    ],
                    op: 0
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
          op: 0
        }
      },
      stmt_location: 3104,
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
                    ],
                    location: 3150
                  }
                },
                location: 3150
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
                              },
                              location: 3167
                            }
                          },
                          location: 3167
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
                              },
                              location: 3175
                            }
                          },
                          location: 3175
                        }
                      },
                      {
                        ResTarget: {
                          val: {
                            A_Const: {
                              val: {
                                Null: {}
                              },
                              location: 3177
                            }
                          },
                          location: 3177
                        }
                      }
                    ],
                    op: 0
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
          op: 0
        }
      },
      stmt_location: 3142,
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
                    ],
                    location: 3226
                  }
                },
                location: 3226
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 3233
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
                            },
                            location: 3247
                          }
                        },
                        {
                          A_Const: {
                            val: {
                              String: {
                                str: 'RFAAAA'
                              }
                            },
                            location: 3252
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
                            },
                            location: 3264
                          }
                        },
                        {
                          A_Const: {
                            val: {
                              String: {
                                str: 'VJAAAA'
                              }
                            },
                            location: 3269
                          }
                        }
                      ]
                    ],
                    op: 0
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
                              str: 'onek'
                            }
                          },
                          {
                            String: {
                              str: 'unique1'
                            }
                          }
                        ],
                        location: 3302
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
                        ],
                        location: 3317
                      }
                    },
                    location: 3315
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
                              str: 'onek'
                            }
                          },
                          {
                            String: {
                              str: 'stringu1'
                            }
                          }
                        ],
                        location: 3325
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
                        ],
                        location: 3341
                      }
                    },
                    location: 3339
                  }
                }
              ],
              location: 3321
            }
          },
          op: 0
        }
      },
      stmt_location: 3190,
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
                    ],
                    location: 3413
                  }
                },
                location: 3413
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 3420
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
                            subLinkType: 4,
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
                                          ],
                                          location: 3445
                                        }
                                      },
                                      location: 3445
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
                                                  },
                                                  location: 3464
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
                                                  },
                                                  location: 3473
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
                                                  },
                                                  location: 3478
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
                                                  },
                                                  location: 3485
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
                                                  },
                                                  location: 3493
                                                }
                                              }
                                            ],
                                            [
                                              {
                                                SubLink: {
                                                  subLinkType: 4,
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
                                                                },
                                                                location: 3509
                                                              }
                                                            },
                                                            location: 3509
                                                          }
                                                        }
                                                      ],
                                                      op: 0
                                                    }
                                                  },
                                                  location: 3501
                                                }
                                              }
                                            ]
                                          ],
                                          op: 0
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
                                          ],
                                          location: 3541
                                        }
                                      },
                                      sortby_dir: 1,
                                      sortby_nulls: 0,
                                      location: -1
                                    }
                                  }
                                ],
                                limitCount: {
                                  A_Const: {
                                    val: {
                                      Integer: {
                                        ival: 1
                                      }
                                    },
                                    location: 3553
                                  }
                                },
                                op: 0
                              }
                            },
                            location: 3437
                          }
                        }
                      ]
                    ],
                    op: 0
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
                        str: 'onek'
                      }
                    },
                    {
                      String: {
                        str: 'unique1'
                      }
                    }
                  ],
                  location: 3574
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
                  ],
                  location: 3589
                }
              },
              location: 3587
            }
          },
          op: 0
        }
      },
      stmt_location: 3345,
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
                    ],
                    location: 3632
                  }
                },
                location: 3632
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek',
                inh: true,
                relpersistence: 'p',
                location: 3639
              }
            }
          ],
          whereClause: {
            SubLink: {
              subLinkType: 2,
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
                        ],
                        location: 3655
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
                        ],
                        location: 3663
                      }
                    }
                  ],
                  row_format: 2,
                  location: 3654
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
                          },
                          location: 3680
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 1
                            }
                          },
                          location: 3682
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
                          },
                          location: 3687
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 0
                            }
                          },
                          location: 3690
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
                          },
                          location: 3695
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 9
                            }
                          },
                          location: 3698
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
                          },
                          location: 3703
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 99
                            }
                          },
                          location: 3706
                        }
                      }
                    ]
                  ],
                  op: 0
                }
              },
              location: 3668
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
                    ],
                    location: 3724
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 3595,
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
                  },
                  location: 3814
                }
              },
              {
                A_Const: {
                  val: {
                    Integer: {
                      ival: 2
                    }
                  },
                  location: 3816
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
                  },
                  location: 3821
                }
              },
              {
                A_Expr: {
                  kind: 0,
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
                      },
                      location: 3823
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 4
                        }
                      },
                      location: 3825
                    }
                  },
                  location: 3824
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
                  },
                  location: 3830
                }
              },
              {
                A_Const: {
                  val: {
                    Float: {
                      str: '77.7'
                    }
                  },
                  location: 3832
                }
              }
            ]
          ],
          op: 0
        }
      },
      stmt_location: 3732,
      stmt_len: 105
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          op: 1,
          all: true,
          larg: {
            SelectStmt: {
              op: 1,
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
                          },
                          location: 3848
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 2
                            }
                          },
                          location: 3850
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
                          },
                          location: 3855
                        }
                      },
                      {
                        A_Expr: {
                          kind: 0,
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
                              },
                              location: 3857
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 4
                                }
                              },
                              location: 3859
                            }
                          },
                          location: 3858
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
                          },
                          location: 3864
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Float: {
                              str: '77.7'
                            }
                          },
                          location: 3866
                        }
                      }
                    ]
                  ],
                  op: 0
                }
              },
              rarg: {
                SelectStmt: {
                  targetList: [
                    {
                      ResTarget: {
                        val: {
                          A_Expr: {
                            kind: 0,
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
                                },
                                location: 3889
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  Integer: {
                                    ival: 2
                                  }
                                },
                                location: 3891
                              }
                            },
                            location: 3890
                          }
                        },
                        location: 3889
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
                            },
                            location: 3894
                          }
                        },
                        location: 3894
                      }
                    }
                  ],
                  op: 0
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
                        ],
                        location: -1
                      }
                    },
                    location: -1
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'int8_tbl',
                    inh: true,
                    relpersistence: 'p',
                    location: 3913
                  }
                }
              ],
              op: 0
            }
          }
        }
      },
      stmt_location: 3838,
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
              relpersistence: 't',
              location: 3974
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
                    typemod: -1,
                    location: 3982
                  }
                },
                is_local: true,
                location: 3979
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 3922,
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
              relpersistence: 'p',
              location: 4001
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
                      },
                      location: 4013
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
                      },
                      location: 4018
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
                      },
                      location: 4022
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
                      },
                      location: 4027
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      },
                      location: 4031
                    }
                  }
                ],
                [
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      },
                      location: 4038
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
                      },
                      location: 4045
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          override: 0
        }
      },
      stmt_location: 3987,
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
                    ],
                    location: 4057
                  }
                },
                location: 4057
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4064
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
                    ],
                    location: 4077
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4048,
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
                    ],
                    location: 4088
                  }
                },
                location: 4088
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4095
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
                    ],
                    location: 4108
                  }
                },
                sortby_dir: 1,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4080,
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
                    ],
                    location: 4137
                  }
                },
                location: 4137
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4144
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
                    ],
                    location: 4157
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 1,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4115,
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
                    ],
                    location: 4180
                  }
                },
                location: 4180
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4187
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
                    ],
                    location: 4200
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4172,
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
                    ],
                    location: 4216
                  }
                },
                location: 4216
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4223
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
                    ],
                    location: 4236
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 2,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4208,
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
              relpersistence: 'p',
              location: 4321
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
      stmt_location: 4255,
      stmt_len: 74
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 0,
          name: 'enable_sort',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'false'
                  }
                },
                location: 4349
              }
            }
          ]
        }
      },
      stmt_location: 4330,
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
                    ],
                    location: 4364
                  }
                },
                location: 4364
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4371
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
                    ],
                    location: 4384
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4355,
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
                    ],
                    location: 4395
                  }
                },
                location: 4395
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4402
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
                    ],
                    location: 4415
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 1,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4387,
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
                    ],
                    location: 4438
                  }
                },
                location: 4438
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4445
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
                    ],
                    location: 4458
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4430,
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
                    ],
                    location: 4474
                  }
                },
                location: 4474
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4481
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
                    ],
                    location: 4494
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 2,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4466,
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
          removeType: 20,
          behavior: 0
        }
      },
      stmt_location: 4513,
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
              relpersistence: 'p',
              location: 4553
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
      stmt_location: 4531,
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
                    ],
                    location: 4576
                  }
                },
                location: 4576
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4583
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
                    ],
                    location: 4596
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4567,
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
                    ],
                    location: 4607
                  }
                },
                location: 4607
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4614
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
                    ],
                    location: 4627
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 1,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4599,
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
                    ],
                    location: 4650
                  }
                },
                location: 4650
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4657
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
                    ],
                    location: 4670
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4642,
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
                    ],
                    location: 4686
                  }
                },
                location: 4686
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4693
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
                    ],
                    location: 4706
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 2,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4678,
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
          removeType: 20,
          behavior: 0
        }
      },
      stmt_location: 4725,
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
              relpersistence: 'p',
              location: 4765
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
      stmt_location: 4743,
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
                    ],
                    location: 4799
                  }
                },
                location: 4799
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4806
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
                    ],
                    location: 4819
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4790,
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
                    ],
                    location: 4830
                  }
                },
                location: 4830
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4837
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
                    ],
                    location: 4850
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 1,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4822,
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
                    ],
                    location: 4873
                  }
                },
                location: 4873
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4880
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
                    ],
                    location: 4893
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4865,
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
                    ],
                    location: 4909
                  }
                },
                location: 4909
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'foo',
                inh: true,
                relpersistence: 'p',
                location: 4916
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
                    ],
                    location: 4929
                  }
                },
                sortby_dir: 2,
                sortby_nulls: 2,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4901,
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
                        ],
                        location: 5063
                      }
                    },
                    location: 5063
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 5070
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ],
                            location: 5082
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            },
                            location: 5092
                          }
                        },
                        location: 5090
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
                                  str: 'stringu1'
                                }
                              }
                            ],
                            location: 5099
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'ATAAAA'
                              }
                            },
                            location: 5110
                          }
                        },
                        location: 5108
                      }
                    }
                  ],
                  location: 5095
                }
              },
              op: 0
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
                defaction: 0,
                location: 5045
              }
            }
          ]
        }
      },
      stmt_location: 4948,
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
                    ],
                    location: 5127
                  }
                },
                location: 5127
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 5134
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ],
                        location: 5146
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        },
                        location: 5156
                      }
                    },
                    location: 5154
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
                              str: 'stringu1'
                            }
                          }
                        ],
                        location: 5163
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'ATAAAA'
                          }
                        },
                        location: 5174
                      }
                    },
                    location: 5172
                  }
                }
              ],
              location: 5159
            }
          },
          op: 0
        }
      },
      stmt_location: 5119,
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
                        ],
                        location: 5211
                      }
                    },
                    location: 5211
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 5224
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ],
                            location: 5236
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            },
                            location: 5246
                          }
                        },
                        location: 5244
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
                                  str: 'stringu1'
                                }
                              }
                            ],
                            location: 5253
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'ATAAAA'
                              }
                            },
                            location: 5264
                          }
                        },
                        location: 5262
                      }
                    }
                  ],
                  location: 5249
                }
              },
              op: 0
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
                defaction: 0,
                location: 5193
              }
            }
          ]
        }
      },
      stmt_location: 5183,
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
                    ],
                    location: 5281
                  }
                },
                location: 5281
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 5294
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ],
                        location: 5306
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        },
                        location: 5316
                      }
                    },
                    location: 5314
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
                              str: 'stringu1'
                            }
                          }
                        ],
                        location: 5323
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'ATAAAA'
                          }
                        },
                        location: 5334
                      }
                    },
                    location: 5332
                  }
                }
              ],
              location: 5319
            }
          },
          op: 0
        }
      },
      stmt_location: 5273,
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
                        ],
                        location: 5436
                      }
                    },
                    location: 5436
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 5443
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ],
                            location: 5455
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            },
                            location: 5465
                          }
                        },
                        location: 5463
                      }
                    },
                    {
                      A_Expr: {
                        kind: 0,
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
                            ],
                            location: 5472
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            },
                            location: 5483
                          }
                        },
                        location: 5481
                      }
                    }
                  ],
                  location: 5468
                }
              },
              op: 0
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
                defaction: 0,
                location: 5418
              }
            }
          ]
        }
      },
      stmt_location: 5343,
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
                    ],
                    location: 5495
                  }
                },
                location: 5495
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 5502
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ],
                        location: 5514
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        },
                        location: 5524
                      }
                    },
                    location: 5522
                  }
                },
                {
                  A_Expr: {
                    kind: 0,
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
                        ],
                        location: 5531
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        },
                        location: 5542
                      }
                    },
                    location: 5540
                  }
                }
              ],
              location: 5527
            }
          },
          op: 0
        }
      },
      stmt_location: 5487,
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
                        ],
                        location: 5574
                      }
                    },
                    location: 5574
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 5587
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ],
                            location: 5599
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            },
                            location: 5609
                          }
                        },
                        location: 5607
                      }
                    },
                    {
                      A_Expr: {
                        kind: 0,
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
                            ],
                            location: 5616
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            },
                            location: 5627
                          }
                        },
                        location: 5625
                      }
                    }
                  ],
                  location: 5612
                }
              },
              op: 0
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
                defaction: 0,
                location: 5556
              }
            }
          ]
        }
      },
      stmt_location: 5546,
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
                    ],
                    location: 5639
                  }
                },
                location: 5639
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 5652
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ],
                        location: 5664
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        },
                        location: 5674
                      }
                    },
                    location: 5672
                  }
                },
                {
                  A_Expr: {
                    kind: 0,
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
                        ],
                        location: 5681
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        },
                        location: 5692
                      }
                    },
                    location: 5690
                  }
                }
              ],
              location: 5677
            }
          },
          op: 0
        }
      },
      stmt_location: 5631,
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
                        ],
                        location: 5776
                      }
                    },
                    location: 5776
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 5789
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ],
                            location: 5801
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            },
                            location: 5811
                          }
                        },
                        location: 5809
                      }
                    },
                    {
                      A_Expr: {
                        kind: 0,
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
                            ],
                            location: 5818
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            },
                            location: 5829
                          }
                        },
                        location: 5827
                      }
                    }
                  ],
                  location: 5814
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
              op: 0
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
                defaction: 0,
                location: 5758
              }
            }
          ]
        }
      },
      stmt_location: 5696,
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
                    ],
                    location: 5852
                  }
                },
                location: 5852
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 5865
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ],
                        location: 5877
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        },
                        location: 5887
                      }
                    },
                    location: 5885
                  }
                },
                {
                  A_Expr: {
                    kind: 0,
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
                        ],
                        location: 5894
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        },
                        location: 5905
                      }
                    },
                    location: 5903
                  }
                }
              ],
              location: 5890
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
          op: 0
        }
      },
      stmt_location: 5844,
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
                        ],
                        location: 5983
                      }
                    },
                    location: 5983
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 5996
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ],
                            location: 6008
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            },
                            location: 6018
                          }
                        },
                        location: 6016
                      }
                    },
                    {
                      A_Expr: {
                        kind: 0,
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
                            ],
                            location: 6025
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'C'
                              }
                            },
                            location: 6036
                          }
                        },
                        location: 6034
                      }
                    }
                  ],
                  location: 6021
                }
              },
              op: 0
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
                defaction: 0,
                location: 5965
              }
            }
          ]
        }
      },
      stmt_location: 5920,
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
                    ],
                    location: 6048
                  }
                },
                location: 6048
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 6061
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ],
                        location: 6073
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        },
                        location: 6083
                      }
                    },
                    location: 6081
                  }
                },
                {
                  A_Expr: {
                    kind: 0,
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
                        ],
                        location: 6090
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'C'
                          }
                        },
                        location: 6101
                      }
                    },
                    location: 6099
                  }
                }
              ],
              location: 6086
            }
          },
          op: 0
        }
      },
      stmt_location: 6040,
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 0,
          name: 'enable_indexscan',
          args: [
            {
              A_Const: {
                val: {
                  String: {
                    str: 'off'
                  }
                },
                location: 6209
              }
            }
          ]
        }
      },
      stmt_location: 6105,
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
                        ],
                        location: 6241
                      }
                    },
                    location: 6241
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 6254
                  }
                }
              ],
              whereClause: {
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
                                  str: 'unique2'
                                }
                              }
                            ],
                            location: 6266
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 11
                              }
                            },
                            location: 6276
                          }
                        },
                        location: 6274
                      }
                    },
                    {
                      A_Expr: {
                        kind: 0,
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
                            ],
                            location: 6283
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            },
                            location: 6294
                          }
                        },
                        location: 6292
                      }
                    }
                  ],
                  location: 6279
                }
              },
              op: 0
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
                defaction: 0,
                location: 6223
              }
            }
          ]
        }
      },
      stmt_location: 6213,
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
                    ],
                    location: 6306
                  }
                },
                location: 6306
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 6319
              }
            }
          ],
          whereClause: {
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
                              str: 'unique2'
                            }
                          }
                        ],
                        location: 6331
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 11
                          }
                        },
                        location: 6341
                      }
                    },
                    location: 6339
                  }
                },
                {
                  A_Expr: {
                    kind: 0,
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
                        ],
                        location: 6348
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        },
                        location: 6359
                      }
                    },
                    location: 6357
                  }
                }
              ],
              location: 6344
            }
          },
          op: 0
        }
      },
      stmt_location: 6298,
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        VariableSetStmt: {
          kind: 4,
          name: 'enable_indexscan'
        }
      },
      stmt_location: 6363,
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
                        ],
                        location: 6446
                      }
                    },
                    location: 6446
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
                        ],
                        location: 6455
                      }
                    },
                    location: 6455
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 6468
                  }
                }
              ],
              whereClause: {
                BoolExpr: {
                  boolop: 0,
                  args: [
                    {
                      BoolExpr: {
                        boolop: 1,
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
                                        str: 'unique2'
                                      }
                                    }
                                  ],
                                  location: 6483
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 11
                                    }
                                  },
                                  location: 6493
                                }
                              },
                              location: 6491
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
                                        str: 'unique1'
                                      }
                                    }
                                  ],
                                  location: 6499
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 0
                                    }
                                  },
                                  location: 6509
                                }
                              },
                              location: 6507
                            }
                          }
                        ],
                        location: 6496
                      }
                    },
                    {
                      A_Expr: {
                        kind: 0,
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
                            ],
                            location: 6516
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              String: {
                                str: 'B'
                              }
                            },
                            location: 6527
                          }
                        },
                        location: 6525
                      }
                    }
                  ],
                  location: 6512
                }
              },
              op: 0
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
                defaction: 0,
                location: 6428
              }
            }
          ]
        }
      },
      stmt_location: 6387,
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
                    ],
                    location: 6539
                  }
                },
                location: 6539
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
                    ],
                    location: 6548
                  }
                },
                location: 6548
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 6561
              }
            }
          ],
          whereClause: {
            BoolExpr: {
              boolop: 0,
              args: [
                {
                  BoolExpr: {
                    boolop: 1,
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
                                    str: 'unique2'
                                  }
                                }
                              ],
                              location: 6576
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 11
                                }
                              },
                              location: 6586
                            }
                          },
                          location: 6584
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
                                    str: 'unique1'
                                  }
                                }
                              ],
                              location: 6592
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 0
                                }
                              },
                              location: 6602
                            }
                          },
                          location: 6600
                        }
                      }
                    ],
                    location: 6589
                  }
                },
                {
                  A_Expr: {
                    kind: 0,
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
                        ],
                        location: 6609
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'B'
                          }
                        },
                        location: 6620
                      }
                    },
                    location: 6618
                  }
                }
              ],
              location: 6605
            }
          },
          op: 0
        }
      },
      stmt_location: 6531,
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
                        ],
                        location: 6652
                      }
                    },
                    location: 6652
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
                        ],
                        location: 6661
                      }
                    },
                    location: 6661
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'onek2',
                    inh: true,
                    relpersistence: 'p',
                    location: 6674
                  }
                }
              ],
              whereClause: {
                BoolExpr: {
                  boolop: 1,
                  args: [
                    {
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
                                        str: 'unique2'
                                      }
                                    }
                                  ],
                                  location: 6689
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 11
                                    }
                                  },
                                  location: 6699
                                }
                              },
                              location: 6697
                            }
                          },
                          {
                            A_Expr: {
                              kind: 0,
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
                                  ],
                                  location: 6706
                                }
                              },
                              rexpr: {
                                A_Const: {
                                  val: {
                                    String: {
                                      str: 'B'
                                    }
                                  },
                                  location: 6717
                                }
                              },
                              location: 6715
                            }
                          }
                        ],
                        location: 6702
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
                                  str: 'unique1'
                                }
                              }
                            ],
                            location: 6725
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 0
                              }
                            },
                            location: 6735
                          }
                        },
                        location: 6733
                      }
                    }
                  ],
                  location: 6722
                }
              },
              op: 0
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
                defaction: 0,
                location: 6634
              }
            }
          ]
        }
      },
      stmt_location: 6624,
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
                    ],
                    location: 6745
                  }
                },
                location: 6745
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
                    ],
                    location: 6754
                  }
                },
                location: 6754
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'onek2',
                inh: true,
                relpersistence: 'p',
                location: 6767
              }
            }
          ],
          whereClause: {
            BoolExpr: {
              boolop: 1,
              args: [
                {
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
                                    str: 'unique2'
                                  }
                                }
                              ],
                              location: 6782
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 11
                                }
                              },
                              location: 6792
                            }
                          },
                          location: 6790
                        }
                      },
                      {
                        A_Expr: {
                          kind: 0,
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
                              ],
                              location: 6799
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'B'
                                }
                              },
                              location: 6810
                            }
                          },
                          location: 6808
                        }
                      }
                    ],
                    location: 6795
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
                              str: 'unique1'
                            }
                          }
                        ],
                        location: 6818
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 0
                          }
                        },
                        location: 6828
                      }
                    },
                    location: 6826
                  }
                }
              ],
              location: 6815
            }
          },
          op: 0
        }
      },
      stmt_location: 6737,
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
                    },
                    location: 6974
                  }
                },
                location: 6974
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
                    ],
                    location: 6990
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6830,
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
                    typemod: -1,
                    location: 7067
                  }
                },
                mode: 105
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
              typemod: -1,
              location: 7086
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
                defaction: 0,
                location: 7090
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
                defaction: 0,
                location: 7122
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
                defaction: 0,
                location: 7135
              }
            }
          ]
        }
      },
      stmt_location: 6992,
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
                          },
                          location: 7163
                        }
                      }
                    ],
                    location: 7154
                  }
                },
                location: 7154
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 7145,
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
                          },
                          location: 7184
                        }
                      }
                    ],
                    location: 7175
                  }
                },
                location: 7175
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
                    },
                    location: 7197
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 7167,
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
                      typemod: -1,
                      location: 7224
                    }
                  }
                ]
              }
            }
          ],
          removeType: 19,
          behavior: 0
        }
      },
      stmt_location: 7199,
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
                    ],
                    location: 7333
                  }
                },
                location: 7333
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
                            },
                            location: 7349
                          }
                        }
                      ],
                      [
                        {
                          A_Const: {
                            val: {
                              Null: {}
                            },
                            location: 7353
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
                            },
                            location: 7360
                          }
                        }
                      ]
                    ],
                    op: 0
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
                        str: 'k'
                      }
                    }
                  ],
                  location: 7375
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
                  ],
                  location: 7379
                }
              },
              location: 7377
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
                    ],
                    location: 7390
                  }
                },
                sortby_dir: 0,
                sortby_nulls: 0,
                location: -1
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 7229,
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
                    ],
                    location: 7400
                  }
                },
                location: 7400
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
                            },
                            location: 7416
                          }
                        }
                      ],
                      [
                        {
                          A_Const: {
                            val: {
                              Null: {}
                            },
                            location: 7420
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
                            },
                            location: 7427
                          }
                        }
                      ]
                    ],
                    op: 0
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
                        str: 'k'
                      }
                    }
                  ],
                  location: 7442
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
                  ],
                  location: 7446
                }
              },
              location: 7444
            }
          },
          op: 0
        }
      },
      stmt_location: 7392,
      stmt_len: 55
    }
  }
];
