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
              relpersistence: 'p',
              location: 12
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name',
                location: 32
              }
            },
            {
              ResTarget: {
                name: 'val',
                location: 38
              }
            },
            {
              ResTarget: {
                name: 'active',
                location: 43
              }
            },
            {
              ResTarget: {
                name: 'hash',
                location: 51
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
                      },
                      location: 73
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'val'
                        }
                      },
                      location: 81
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
                          },
                          location: 88
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
                          typemod: -1,
                          location: -1
                        }
                      },
                      location: -1
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'abcdefg'
                        }
                      },
                      location: 94
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
                      },
                      location: 111
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'val'
                        }
                      },
                      location: 119
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
                          },
                          location: 126
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
                          typemod: -1,
                          location: -1
                        }
                      },
                      location: -1
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'abcdefg'
                        }
                      },
                      location: 132
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
                      },
                      location: 149
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'val'
                        }
                      },
                      location: 157
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
                          },
                          location: 164
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
                          typemod: -1,
                          location: -1
                        }
                      },
                      location: -1
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'abcdefg'
                        }
                      },
                      location: 170
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
              relpersistence: 'p',
              location: 196
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'project_id',
                location: 206
              }
            },
            {
              ResTarget: {
                name: 'name',
                location: 218
              }
            },
            {
              ResTarget: {
                name: 'field_name',
                location: 224
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
                      ],
                      location: 246
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
                          ],
                          location: 260
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
                          typemod: -1,
                          location: 275
                        }
                      },
                      location: 273
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
                      ],
                      location: 282
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 2,
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    },
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    }
                  ],
                  location: 312
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
                        ],
                        location: 368
                      }
                    },
                    location: 355
                  }
                }
              ],
              location: 300
            }
          },
          override: 0
        }
      },
      stmt_location: 181,
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
              relpersistence: 'p',
              location: 403
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'project_id',
                location: 413
              }
            },
            {
              ResTarget: {
                name: 'name',
                location: 425
              }
            },
            {
              ResTarget: {
                name: 'field_name',
                location: 431
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
                      ],
                      location: 453
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
                          ],
                          location: 467
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
                          typemod: -1,
                          location: 482
                        }
                      },
                      location: 480
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
                      ],
                      location: 489
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 2,
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    },
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    }
                  ],
                  location: 519
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
                        ],
                        location: 575
                      }
                    },
                    location: 562
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
                            str: 'prop'
                          }
                        }
                      ],
                      location: 603
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 1
                        }
                      },
                      location: 610
                    }
                  },
                  location: 608
                }
              },
              location: 507
            }
          },
          override: 0
        }
      },
      stmt_location: 388,
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
              relpersistence: 'p',
              location: 626
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'project_id',
                location: 636
              }
            },
            {
              ResTarget: {
                name: 'name',
                location: 648
              }
            },
            {
              ResTarget: {
                name: 'field_name',
                location: 654
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
                      ],
                      location: 676
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
                          ],
                          location: 690
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
                          typemod: -1,
                          location: 705
                        }
                      },
                      location: 703
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
                      ],
                      location: 712
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 1,
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    },
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    }
                  ],
                  location: 742
                }
              },
              location: 730
            }
          },
          override: 0
        }
      },
      stmt_location: 612,
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
              relpersistence: 'p',
              location: 788
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name',
                location: 799
              }
            },
            {
              ResTarget: {
                name: 'email',
                location: 805
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
                      },
                      location: 824
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      },
                      location: 839
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 1,
              infer: {
                InferClause: {
                  conname: 'customers_name_key',
                  location: 880
                }
              },
              location: 867
            }
          },
          override: 0
        }
      },
      stmt_location: 774,
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
              relpersistence: 'p',
              location: 940
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name',
                location: 951
              }
            },
            {
              ResTarget: {
                name: 'email',
                location: 957
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
                      },
                      location: 976
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      },
                      location: 991
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 2,
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    }
                  ],
                  location: 1031
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'email',
                    val: {
                      A_Expr: {
                        kind: 0,
                        name: [
                          {
                            String: {
                              str: '||'
                            }
                          }
                        ],
                        lexpr: {
                          A_Expr: {
                            kind: 0,
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
                                ],
                                location: 1066
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  String: {
                                    str: ';'
                                  }
                                },
                                location: 1084
                              }
                            },
                            location: 1081
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
                            ],
                            location: 1091
                          }
                        },
                        location: 1088
                      }
                    },
                    location: 1058
                  }
                }
              ],
              location: 1019
            }
          },
          override: 0
        }
      },
      stmt_location: 925,
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
              relpersistence: 'p',
              location: 1122
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name',
                location: 1133
              }
            },
            {
              ResTarget: {
                name: 'email',
                location: 1139
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
                      },
                      location: 1158
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      },
                      location: 1173
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 2,
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'name',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    }
                  ],
                  location: 1213
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'email',
                    val: {
                      A_Expr: {
                        kind: 0,
                        name: [
                          {
                            String: {
                              str: '||'
                            }
                          }
                        ],
                        lexpr: {
                          A_Expr: {
                            kind: 0,
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
                                ],
                                location: 1257
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  String: {
                                    str: ';'
                                  }
                                },
                                location: 1275
                              }
                            },
                            location: 1272
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
                            ],
                            location: 1282
                          }
                        },
                        location: 1279
                      }
                    },
                    location: 1249
                  }
                },
                {
                  ResTarget: {
                    name: 'level',
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
                            ],
                            location: 1315
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 1
                              }
                            },
                            location: 1333
                          }
                        },
                        location: 1331
                      }
                    },
                    location: 1307
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
                        ],
                        location: 1352
                      }
                    },
                    location: 1344
                  }
                }
              ],
              location: 1201
            }
          },
          override: 0
        }
      },
      stmt_location: 1107,
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
              relpersistence: 'p',
              location: 1382
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'name',
                location: 1393
              }
            },
            {
              ResTarget: {
                name: 'email',
                location: 1399
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
                      },
                      location: 1418
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'hotline@microsoft.com'
                        }
                      },
                      location: 1433
                    }
                  }
                ]
              ],
              op: 0
            }
          },
          onConflictClause: {
            OnConflictClause: {
              action: 2,
              infer: {
                InferClause: {
                  indexElems: [
                    {
                      IndexElem: {
                        name: 'id',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    },
                    {
                      IndexElem: {
                        name: 'project_id',
                        ordering: 0,
                        nulls_ordering: 0
                      }
                    }
                  ],
                  location: 1473
                }
              },
              targetList: [
                {
                  ResTarget: {
                    name: 'email',
                    val: {
                      A_Expr: {
                        kind: 0,
                        name: [
                          {
                            String: {
                              str: '||'
                            }
                          }
                        ],
                        lexpr: {
                          A_Expr: {
                            kind: 0,
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
                                ],
                                location: 1527
                              }
                            },
                            rexpr: {
                              A_Const: {
                                val: {
                                  String: {
                                    str: ';'
                                  }
                                },
                                location: 1545
                              }
                            },
                            location: 1542
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
                            ],
                            location: 1552
                          }
                        },
                        location: 1549
                      }
                    },
                    location: 1519
                  }
                },
                {
                  ResTarget: {
                    name: 'level',
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
                            ],
                            location: 1585
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 1
                              }
                            },
                            location: 1603
                          }
                        },
                        location: 1601
                      }
                    },
                    location: 1577
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
                        ],
                        location: 1622
                      }
                    },
                    location: 1614
                  }
                }
              ],
              location: 1461
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
                    ],
                    location: 1651
                  }
                },
                location: 1651
              }
            }
          ],
          override: 0
        }
      },
      stmt_location: 1367,
      stmt_len: 285
    }
  }
];
