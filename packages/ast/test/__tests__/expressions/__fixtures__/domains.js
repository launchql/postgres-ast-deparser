export const domains = [
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'domaindroptest'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              typemod: -1,
              location: 29
            }
          }
        }
      },
      stmt_len: 33
    }
  },
  {
    RawStmt: {
      stmt: {
        CommentStmt: {
          objtype: 12,
          object: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'domaindoptest'
                  }
                }
              ],
              typemod: -1,
              location: 53
            }
          },
          comment: 'About to drop this..'
        }
      },
      stmt_location: 34,
      stmt_len: 59
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dependenttypetest'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'domaindroptest'
                  }
                }
              ],
              typemod: -1,
              location: 127
            }
          }
        }
      },
      stmt_location: 94,
      stmt_len: 47
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domaindroptest'
                    }
                  }
                ],
                typemod: -1,
                location: 155
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 142,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domaindroptest'
                    }
                  }
                ],
                typemod: -1,
                location: 183
              }
            }
          ],
          removeType: 12,
          behavior: 1
        }
      },
      stmt_location: 170,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domaindroptest'
                    }
                  }
                ],
                typemod: -1,
                location: 219
              }
            }
          ],
          removeType: 12,
          behavior: 1
        }
      },
      stmt_location: 206,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'domainvarchar'
              }
            }
          ],
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
                    str: 'varchar'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 5
                      }
                    },
                    location: 279
                  }
                }
              ],
              typemod: -1,
              location: 271
            }
          }
        }
      },
      stmt_location: 242,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'domainnumeric'
              }
            }
          ],
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
                    str: 'numeric'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 8
                      }
                    },
                    location: 319
                  }
                },
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 2
                      }
                    },
                    location: 321
                  }
                }
              ],
              typemod: -1,
              location: 311
            }
          }
        }
      },
      stmt_location: 282,
      stmt_len: 41
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'domainint4'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              typemod: -1,
              location: 350
            }
          }
        }
      },
      stmt_location: 324,
      stmt_len: 30
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'domaintext'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'text'
                  }
                }
              ],
              typemod: -1,
              location: 381
            }
          }
        }
      },
      stmt_location: 355,
      stmt_len: 30
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'basictest',
              inh: true,
              relpersistence: 'p',
              location: 400
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'testint4',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'domainint4'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 432
                  }
                },
                is_local: true,
                location: 423
              }
            },
            {
              ColumnDef: {
                colname: 'testtext',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'domaintext'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 465
                  }
                },
                is_local: true,
                location: 456
              }
            },
            {
              ColumnDef: {
                colname: 'testvarchar',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'domainvarchar'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 501
                  }
                },
                is_local: true,
                location: 489
              }
            },
            {
              ColumnDef: {
                colname: 'testnumeric',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'domainnumeric'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 540
                  }
                },
                is_local: true,
                location: 528
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 386,
      stmt_len: 180
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                name: 't',
                val: {
                  A_Expr: {
                    kind: 6,
                    name: [
                      {
                        String: {
                          str: '='
                        }
                      }
                    ],
                    lexpr: {
                      CoalesceExpr: {
                        args: [
                          {
                            TypeCast: {
                              arg: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 4
                                    }
                                  },
                                  location: 660
                                }
                              },
                              typeName: {
                                TypeName: {
                                  names: [
                                    {
                                      String: {
                                        str: 'domainint4'
                                      }
                                    }
                                  ],
                                  typemod: -1,
                                  location: 663
                                }
                              },
                              location: 661
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 7
                                }
                              },
                              location: 675
                            }
                          }
                        ],
                        location: 651
                      }
                    },
                    rexpr: [
                      {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'int4'
                              }
                            }
                          ],
                          typemod: -1,
                          location: 685
                        }
                      }
                    ],
                    location: 678
                  }
                },
                location: 651
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 567,
      stmt_len: 128
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                name: 'f',
                val: {
                  A_Expr: {
                    kind: 6,
                    name: [
                      {
                        String: {
                          str: '='
                        }
                      }
                    ],
                    lexpr: {
                      CoalesceExpr: {
                        args: [
                          {
                            TypeCast: {
                              arg: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 4
                                    }
                                  },
                                  location: 713
                                }
                              },
                              typeName: {
                                TypeName: {
                                  names: [
                                    {
                                      String: {
                                        str: 'domainint4'
                                      }
                                    }
                                  ],
                                  typemod: -1,
                                  location: 716
                                }
                              },
                              location: 714
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 7
                                }
                              },
                              location: 728
                            }
                          }
                        ],
                        location: 704
                      }
                    },
                    rexpr: [
                      {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'domainint4'
                              }
                            }
                          ],
                          typemod: -1,
                          location: 738
                        }
                      }
                    ],
                    location: 731
                  }
                },
                location: 704
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 696,
      stmt_len: 58
    }
  },
  {
    RawStmt: {
      stmt: {
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                name: 't',
                val: {
                  A_Expr: {
                    kind: 6,
                    name: [
                      {
                        String: {
                          str: '='
                        }
                      }
                    ],
                    lexpr: {
                      CoalesceExpr: {
                        args: [
                          {
                            TypeCast: {
                              arg: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 4
                                    }
                                  },
                                  location: 772
                                }
                              },
                              typeName: {
                                TypeName: {
                                  names: [
                                    {
                                      String: {
                                        str: 'domainint4'
                                      }
                                    }
                                  ],
                                  typemod: -1,
                                  location: 775
                                }
                              },
                              location: 773
                            }
                          },
                          {
                            TypeCast: {
                              arg: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 7
                                    }
                                  },
                                  location: 787
                                }
                              },
                              typeName: {
                                TypeName: {
                                  names: [
                                    {
                                      String: {
                                        str: 'domainint4'
                                      }
                                    }
                                  ],
                                  typemod: -1,
                                  location: 790
                                }
                              },
                              location: 788
                            }
                          }
                        ],
                        location: 763
                      }
                    },
                    rexpr: [
                      {
                        TypeName: {
                          names: [
                            {
                              String: {
                                str: 'domainint4'
                              }
                            }
                          ],
                          typemod: -1,
                          location: 809
                        }
                      }
                    ],
                    location: 802
                  }
                },
                location: 763
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 755,
      stmt_len: 70
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
                  str: 'basictest'
                }
              }
            ]
          ],
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 826,
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domainvarchar'
                    }
                  }
                ],
                typemod: -1,
                location: 862
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 849,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domainnumeric'
                    }
                  }
                ],
                typemod: -1,
                location: 898
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 885,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domainint4'
                    }
                  }
                ],
                typemod: -1,
                location: 934
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 921,
      stmt_len: 32
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domaintext'
                    }
                  }
                ],
                typemod: -1,
                location: 967
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 954,
      stmt_len: 23
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'domainint4arr'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              typemod: -1,
              arrayBounds: [
                {
                  Integer: {
                    ival: 1
                  }
                }
              ],
              location: 1043
            }
          }
        }
      },
      stmt_location: 978,
      stmt_len: 72
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'domainchar4arr'
              }
            }
          ],
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
                    str: 'varchar'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 4
                      }
                    },
                    location: 1089
                  }
                }
              ],
              typemod: -1,
              arrayBounds: [
                {
                  Integer: {
                    ival: 2
                  }
                },
                {
                  Integer: {
                    ival: 3
                  }
                }
              ],
              location: 1081
            }
          }
        }
      },
      stmt_location: 1051,
      stmt_len: 46
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domainint4arr'
                    }
                  }
                ],
                typemod: -1,
                location: 1112
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 1098,
      stmt_len: 36
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domainchar4arr'
                    }
                  }
                ],
                typemod: -1,
                location: 1148
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 1135,
      stmt_len: 36
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dia'
              }
            }
          ],
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
              arrayBounds: [
                {
                  Integer: {
                    ival: -1
                  }
                }
              ],
              location: 1195
            }
          }
        }
      },
      stmt_location: 1172,
      stmt_len: 28
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'dia'
                    }
                  }
                ],
                typemod: -1,
                location: 1214
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 1201,
      stmt_len: 16
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dnotnull'
              }
            }
          ],
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
                    str: 'varchar'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 15
                      }
                    },
                    location: 1251
                  }
                }
              ],
              typemod: -1,
              location: 1243
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 1,
                location: 1255
              }
            }
          ]
        }
      },
      stmt_location: 1218,
      stmt_len: 45
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dnull'
              }
            }
          ],
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
                    str: 'varchar'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 15
                      }
                    },
                    location: 1296
                  }
                }
              ],
              typemod: -1,
              location: 1288
            }
          }
        }
      },
      stmt_location: 1264,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dcheck'
              }
            }
          ],
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
                    str: 'varchar'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 15
                      }
                    },
                    location: 1332
                  }
                }
              ],
              typemod: -1,
              location: 1324
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 1,
                location: 1336
              }
            },
            {
              Constraint: {
                contype: 4,
                location: 1345,
                raw_expr: {
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
                                    str: 'value'
                                  }
                                }
                              ],
                              location: 1352
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'a'
                                }
                              },
                              location: 1360
                            }
                          },
                          location: 1358
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
                                    str: 'value'
                                  }
                                }
                              ],
                              location: 1367
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'c'
                                }
                              },
                              location: 1375
                            }
                          },
                          location: 1373
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
                                    str: 'value'
                                  }
                                }
                              ],
                              location: 1382
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'd'
                                }
                              },
                              location: 1390
                            }
                          },
                          location: 1388
                        }
                      }
                    ],
                    location: 1364
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 1300,
      stmt_len: 94
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1410
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'col1',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'dnotnull'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 1437
                  }
                },
                is_local: true,
                location: 1432
              }
            },
            {
              ColumnDef: {
                colname: 'col2',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'dnotnull'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 1464
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 0,
                      location: 1473
                    }
                  }
                ],
                location: 1459
              }
            },
            {
              ColumnDef: {
                colname: 'col3',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'dnull'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 1544
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 1,
                      location: 1553
                    }
                  }
                ],
                location: 1539
              }
            },
            {
              ColumnDef: {
                colname: 'col4',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'dnull'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 1580
                  }
                },
                is_local: true,
                location: 1575
              }
            },
            {
              ColumnDef: {
                colname: 'col5',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'dcheck'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 1604
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 4,
                      location: 1611,
                      raw_expr: {
                        A_Expr: {
                          kind: 7,
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
                                    str: 'col5'
                                  }
                                }
                              ],
                              location: 1618
                            }
                          },
                          rexpr: [
                            {
                              A_Const: {
                                val: {
                                  String: {
                                    str: 'c'
                                  }
                                },
                                location: 1627
                              }
                            },
                            {
                              A_Const: {
                                val: {
                                  String: {
                                    str: 'd'
                                  }
                                },
                                location: 1632
                              }
                            }
                          ],
                          location: 1623
                        }
                      },
                      initially_valid: true
                    }
                  }
                ],
                location: 1599
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 1395,
      stmt_len: 255
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1664
            }
          },
          override: 0
        }
      },
      stmt_location: 1651,
      stmt_len: 36
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1701
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
                        }
                      },
                      location: 1718
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      },
                      location: 1723
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 1728
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 1733
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 1738
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
      stmt_location: 1688,
      stmt_len: 54
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1765
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
                        }
                      },
                      location: 1782
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      },
                      location: 1787
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 1792
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 1797
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      },
                      location: 1802
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
      stmt_location: 1743,
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1821
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
                        }
                      },
                      location: 1838
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      },
                      location: 1843
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 1848
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 1853
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
                        }
                      },
                      location: 1858
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
      stmt_location: 1808,
      stmt_len: 54
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1876
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      },
                      location: 1893
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      },
                      location: 1899
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 1904
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 1909
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 1914
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
      stmt_location: 1863,
      stmt_len: 55
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1932
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
                        }
                      },
                      location: 1949
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      },
                      location: 1954
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 1960
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 1965
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 1970
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
      stmt_location: 1919,
      stmt_len: 55
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 1988
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
                        }
                      },
                      location: 2005
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      },
                      location: 2010
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      },
                      location: 2015
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 2021
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 2026
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
      stmt_location: 1975,
      stmt_len: 55
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'nulltest',
              inh: true,
              relpersistence: 'p',
              location: 2044
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
                        }
                      },
                      location: 2061
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      },
                      location: 2066
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      },
                      location: 2071
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      },
                      location: 2076
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      },
                      location: 2082
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
      stmt_location: 2031,
      stmt_len: 55
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
                    location: 2104
                  }
                },
                location: 2104
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'nulltest',
                inh: true,
                relpersistence: 'p',
                location: 2111
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2087,
      stmt_len: 32
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          String: {
                            str: '1'
                          }
                        },
                        location: 2175
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dnotnull'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 2182
                      }
                    },
                    location: 2170
                  }
                },
                location: 2170
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2120,
      stmt_len: 71
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          Null: {}
                        },
                        location: 2205
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dnotnull'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 2213
                      }
                    },
                    location: 2200
                  }
                },
                location: 2200
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2192,
      stmt_len: 30
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
                  TypeCast: {
                    arg: {
                      TypeCast: {
                        arg: {
                          A_Const: {
                            val: {
                              Null: {}
                            },
                            location: 2249
                          }
                        },
                        typeName: {
                          TypeName: {
                            names: [
                              {
                                String: {
                                  str: 'dnull'
                                }
                              }
                            ],
                            typemod: -1,
                            location: 2257
                          }
                        },
                        location: 2244
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dnotnull'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 2267
                      }
                    },
                    location: 2239
                  }
                },
                location: 2239
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2223,
      stmt_len: 53
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
                  TypeCast: {
                    arg: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'col4'
                            }
                          }
                        ],
                        location: 2298
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dnotnull'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 2306
                      }
                    },
                    location: 2293
                  }
                },
                location: 2293
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'nulltest',
                inh: true,
                relpersistence: 'p',
                location: 2321
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 2277,
      stmt_len: 52
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
                  str: 'nulltest'
                }
              }
            ]
          ],
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 2330,
      stmt_len: 40
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'dnotnull'
                    }
                  }
                ],
                typemod: -1,
                location: 2384
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 2371,
      stmt_len: 30
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'dnull'
                    }
                  }
                ],
                typemod: -1,
                location: 2415
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 2402,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'dcheck'
                    }
                  }
                ],
                typemod: -1,
                location: 2443
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 2430,
      stmt_len: 28
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'ddef1'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              typemod: -1,
              location: 2482
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 2,
                location: 2487,
                raw_expr: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 3
                      }
                    },
                    location: 2495
                  }
                }
              }
            }
          ]
        }
      },
      stmt_location: 2459,
      stmt_len: 37
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'ddef2'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'oid'
                  }
                }
              ],
              typemod: -1,
              location: 2518
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 2,
                location: 2522,
                raw_expr: {
                  A_Const: {
                    val: {
                      String: {
                        str: '12'
                      }
                    },
                    location: 2530
                  }
                }
              }
            }
          ]
        }
      },
      stmt_location: 2497,
      stmt_len: 37
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'ddef3'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'text'
                  }
                }
              ],
              typemod: -1,
              location: 2594
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 2,
                location: 2599,
                raw_expr: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 5
                      }
                    },
                    location: 2607
                  }
                }
              }
            }
          ]
        }
      },
      stmt_location: 2535,
      stmt_len: 73
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateSeqStmt: {
          sequence: {
            RangeVar: {
              relname: 'ddef4_seq',
              inh: true,
              relpersistence: 'p',
              location: 2626
            }
          }
        }
      },
      stmt_location: 2609,
      stmt_len: 26
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'ddef4'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              typemod: -1,
              location: 2657
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 2,
                location: 2662,
                raw_expr: {
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'nextval'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            String: {
                              str: 'ddef4_seq'
                            }
                          },
                          location: 2678
                        }
                      }
                    ],
                    location: 2670
                  }
                }
              }
            }
          ]
        }
      },
      stmt_location: 2636,
      stmt_len: 54
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'ddef5'
              }
            }
          ],
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
                    str: 'numeric'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 8
                      }
                    },
                    location: 2720
                  }
                },
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 2
                      }
                    },
                    location: 2722
                  }
                }
              ],
              typemod: -1,
              location: 2712
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 1,
                location: 2725
              }
            },
            {
              Constraint: {
                contype: 2,
                location: 2734,
                raw_expr: {
                  A_Const: {
                    val: {
                      String: {
                        str: '12.12'
                      }
                    },
                    location: 2742
                  }
                }
              }
            }
          ]
        }
      },
      stmt_location: 2691,
      stmt_len: 58
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 2765
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'col1',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef1'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 2796
                  }
                },
                is_local: true,
                location: 2791
              }
            },
            {
              ColumnDef: {
                colname: 'col2',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef2'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 2821
                  }
                },
                is_local: true,
                location: 2816
              }
            },
            {
              ColumnDef: {
                colname: 'col3',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef3'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 2846
                  }
                },
                is_local: true,
                location: 2841
              }
            },
            {
              ColumnDef: {
                colname: 'col4',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef4'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 2871
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 5,
                      location: 2877
                    }
                  }
                ],
                location: 2866
              }
            },
            {
              ColumnDef: {
                colname: 'col5',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef1'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 2908
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 1,
                      location: 2914
                    }
                  },
                  {
                    Constraint: {
                      contype: 2,
                      location: 2923,
                      raw_expr: {
                        A_Const: {
                          val: {
                            Null: {}
                          },
                          location: 2931
                        }
                      }
                    }
                  }
                ],
                location: 2903
              }
            },
            {
              ColumnDef: {
                colname: 'col6',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef2'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 2955
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 2,
                      location: 2961,
                      raw_expr: {
                        A_Const: {
                          val: {
                            String: {
                              str: '88'
                            }
                          },
                          location: 2969
                        }
                      }
                    }
                  }
                ],
                location: 2950
              }
            },
            {
              ColumnDef: {
                colname: 'col7',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef4'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 2993
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 2,
                      location: 2999,
                      raw_expr: {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 8000
                            }
                          },
                          location: 3007
                        }
                      }
                    }
                  }
                ],
                location: 2988
              }
            },
            {
              ColumnDef: {
                colname: 'col8',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef5'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 3031
                  }
                },
                is_local: true,
                location: 3026
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 2750,
      stmt_len: 300
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3064
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col4',
                location: 3076
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
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 3089
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
      stmt_location: 3051,
      stmt_len: 40
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterTableStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3137
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 3,
                name: 'col5',
                behavior: 0
              }
            }
          ],
          relkind: 37
        }
      },
      stmt_location: 3092,
      stmt_len: 87
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3193
            }
          },
          override: 0
        }
      },
      stmt_location: 3180,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterTableStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3343
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 3,
                name: 'col5',
                def: {
                  A_Const: {
                    val: {
                      Null: {}
                    },
                    location: 3385
                  }
                },
                behavior: 0
              }
            }
          ],
          relkind: 37
        }
      },
      stmt_location: 3220,
      stmt_len: 169
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3403
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col4',
                location: 3415
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
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 3428
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
      stmt_location: 3390,
      stmt_len: 40
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterTableStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3453
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 3,
                name: 'col5',
                behavior: 0
              }
            }
          ],
          relkind: 37
        }
      },
      stmt_location: 3431,
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3509
            }
          },
          override: 0
        }
      },
      stmt_location: 3496,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p',
              location: 3549
            }
          },
          override: 0
        }
      },
      stmt_location: 3536,
      stmt_len: 39
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
                    location: 3585
                  }
                },
                location: 3585
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'defaulttest',
                inh: true,
                relpersistence: 'p',
                location: 3592
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 3576,
      stmt_len: 27
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
                  str: 'defaulttest'
                }
              }
            ]
          ],
          removeType: 37,
          behavior: 1
        }
      },
      stmt_location: 3604,
      stmt_len: 32
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dnotnulltest'
              }
            }
          ],
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
              location: 3699
            }
          }
        }
      },
      stmt_location: 3637,
      stmt_len: 69
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'domnotnull',
              inh: true,
              relpersistence: 'p',
              location: 3721
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'col1',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'dnotnulltest'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 3739
                  }
                },
                is_local: true,
                location: 3734
              }
            },
            {
              ColumnDef: {
                colname: 'col2',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'dnotnulltest'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 3759
                  }
                },
                is_local: true,
                location: 3754
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 3707,
      stmt_len: 66
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domnotnull',
              inh: true,
              relpersistence: 'p',
              location: 3788
            }
          },
          override: 0
        }
      },
      stmt_location: 3774,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'O',
          typeName: [
            {
              String: {
                str: 'dnotnulltest'
              }
            }
          ],
          behavior: 0
        }
      },
      stmt_location: 3814,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        UpdateStmt: {
          relation: {
            RangeVar: {
              relname: 'domnotnull',
              inh: true,
              relpersistence: 'p',
              location: 3872
            }
          },
          targetList: [
            {
              ResTarget: {
                name: 'col1',
                val: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 5
                      }
                    },
                    location: 3894
                  }
                },
                location: 3887
              }
            }
          ]
        }
      },
      stmt_location: 3854,
      stmt_len: 41
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'O',
          typeName: [
            {
              String: {
                str: 'dnotnulltest'
              }
            }
          ],
          behavior: 0
        }
      },
      stmt_location: 3896,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        UpdateStmt: {
          relation: {
            RangeVar: {
              relname: 'domnotnull',
              inh: true,
              relpersistence: 'p',
              location: 3954
            }
          },
          targetList: [
            {
              ResTarget: {
                name: 'col2',
                val: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 6
                      }
                    },
                    location: 3976
                  }
                },
                location: 3969
              }
            }
          ]
        }
      },
      stmt_location: 3936,
      stmt_len: 41
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'O',
          typeName: [
            {
              String: {
                str: 'dnotnulltest'
              }
            }
          ],
          behavior: 0
        }
      },
      stmt_location: 3978,
      stmt_len: 40
    }
  },
  {
    RawStmt: {
      stmt: {
        UpdateStmt: {
          relation: {
            RangeVar: {
              relname: 'domnotnull',
              inh: true,
              relpersistence: 'p',
              location: 4028
            }
          },
          targetList: [
            {
              ResTarget: {
                name: 'col1',
                val: {
                  A_Const: {
                    val: {
                      Null: {}
                    },
                    location: 4050
                  }
                },
                location: 4043
              }
            }
          ]
        }
      },
      stmt_location: 4019,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'N',
          typeName: [
            {
              String: {
                str: 'dnotnulltest'
              }
            }
          ],
          behavior: 0
        }
      },
      stmt_location: 4055,
      stmt_len: 50
    }
  },
  {
    RawStmt: {
      stmt: {
        UpdateStmt: {
          relation: {
            RangeVar: {
              relname: 'domnotnull',
              inh: true,
              relpersistence: 'p',
              location: 4115
            }
          },
          targetList: [
            {
              ResTarget: {
                name: 'col1',
                val: {
                  A_Const: {
                    val: {
                      Null: {}
                    },
                    location: 4137
                  }
                },
                location: 4130
              }
            }
          ]
        }
      },
      stmt_location: 4106,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'dnotnulltest'
                    }
                  }
                ],
                typemod: -1,
                location: 4156
              }
            }
          ],
          removeType: 12,
          behavior: 1
        }
      },
      stmt_location: 4142,
      stmt_len: 34
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'domdeftest',
              inh: true,
              relpersistence: 'p',
              location: 4227
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'col1',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'ddef1'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 4244
                  }
                },
                is_local: true,
                location: 4239
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 4177,
      stmt_len: 73
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domdeftest',
              inh: true,
              relpersistence: 'p',
              location: 4265
            }
          },
          override: 0
        }
      },
      stmt_location: 4251,
      stmt_len: 39
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
                    location: 4299
                  }
                },
                location: 4299
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domdeftest',
                inh: true,
                relpersistence: 'p',
                location: 4306
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4291,
      stmt_len: 25
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'T',
          typeName: [
            {
              String: {
                str: 'ddef1'
              }
            }
          ],
          def: {
            A_Const: {
              val: {
                String: {
                  str: '42'
                }
              },
              location: 4350
            }
          },
          behavior: 0
        }
      },
      stmt_location: 4317,
      stmt_len: 37
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domdeftest',
              inh: true,
              relpersistence: 'p',
              location: 4368
            }
          },
          override: 0
        }
      },
      stmt_location: 4355,
      stmt_len: 38
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
                    location: 4402
                  }
                },
                location: 4402
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domdeftest',
                inh: true,
                relpersistence: 'p',
                location: 4409
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4394,
      stmt_len: 25
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'T',
          typeName: [
            {
              String: {
                str: 'ddef1'
              }
            }
          ],
          behavior: 0
        }
      },
      stmt_location: 4420,
      stmt_len: 33
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domdeftest',
              inh: true,
              relpersistence: 'p',
              location: 4467
            }
          },
          override: 0
        }
      },
      stmt_location: 4454,
      stmt_len: 38
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
                    location: 4501
                  }
                },
                location: 4501
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domdeftest',
                inh: true,
                relpersistence: 'p',
                location: 4508
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 4493,
      stmt_len: 25
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
                  str: 'domdeftest'
                }
              }
            ]
          ],
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 4519,
      stmt_len: 23
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'con'
              }
            }
          ],
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
              location: 4604
            }
          }
        }
      },
      stmt_location: 4543,
      stmt_len: 68
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 4626
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'col1',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'con'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 4643
                  }
                },
                is_local: true,
                location: 4638
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 4612,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 4662
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
                          ival: 1
                        }
                      },
                      location: 4681
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
      stmt_location: 4648,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 4697
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
                          ival: 2
                        }
                      },
                      location: 4716
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
      stmt_location: 4684,
      stmt_len: 34
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'con'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 't',
              location: 4741,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 4761
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 1
                        }
                      },
                      location: 4769
                    }
                  },
                  location: 4767
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 4719,
      stmt_len: 52
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'con'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 't',
              location: 4804,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 4824
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 34
                        }
                      },
                      location: 4832
                    }
                  },
                  location: 4830
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 4772,
      stmt_len: 63
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'con'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              location: 4858,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 4865
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 4873
                    }
                  },
                  location: 4871
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 4836,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 4890
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
                          ival: -5
                        }
                      },
                      location: 4909
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
      stmt_location: 4876,
      stmt_len: 36
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 4935
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
                      location: 4954
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
      stmt_location: 4913,
      stmt_len: 44
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 4980
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
                          ival: 5
                        }
                      },
                      location: 4999
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
      stmt_location: 4958,
      stmt_len: 43
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'X',
          typeName: [
            {
              String: {
                str: 'con'
              }
            }
          ],
          name: 't',
          behavior: 0
        }
      },
      stmt_location: 5002,
      stmt_len: 36
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 5052
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
                          ival: -5
                        }
                      },
                      location: 5071
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
      stmt_location: 5039,
      stmt_len: 35
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domcontest',
              inh: true,
              relpersistence: 'p',
              location: 5096
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
                      location: 5115
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
      stmt_location: 5075,
      stmt_len: 43
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'X',
          typeName: [
            {
              String: {
                str: 'con'
              }
            }
          ],
          name: 'nonexistent',
          behavior: 0
        }
      },
      stmt_location: 5119,
      stmt_len: 46
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'X',
          typeName: [
            {
              String: {
                str: 'con'
              }
            }
          ],
          name: 'nonexistent',
          behavior: 0,
          missing_ok: true
        }
      },
      stmt_location: 5166,
      stmt_len: 55
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'things'
              }
            }
          ],
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
              location: 5296
            }
          }
        }
      },
      stmt_location: 5222,
      stmt_len: 77
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'thethings',
              inh: true,
              relpersistence: 'p',
              location: 5314
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'stuff',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'things'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 5331
                  }
                },
                is_local: true,
                location: 5325
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 5300,
      stmt_len: 38
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'thethings',
              inh: true,
              relpersistence: 'p',
              location: 5352
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'stuff',
                location: 5363
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
                        Integer: {
                          ival: 55
                        }
                      },
                      location: 5378
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
      stmt_location: 5339,
      stmt_len: 42
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'things'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'meow',
              location: 5407,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 5430
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 11
                        }
                      },
                      location: 5438
                    }
                  },
                  location: 5436
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 5382,
      stmt_len: 59
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'things'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'meow',
              location: 5467,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 5490
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 11
                        }
                      },
                      location: 5498
                    }
                  },
                  location: 5496
                }
              },
              skip_validation: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 5442,
      stmt_len: 69
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'V',
          typeName: [
            {
              String: {
                str: 'things'
              }
            }
          ],
          name: 'meow',
          behavior: 0
        }
      },
      stmt_location: 5512,
      stmt_len: 45
    }
  },
  {
    RawStmt: {
      stmt: {
        UpdateStmt: {
          relation: {
            RangeVar: {
              relname: 'thethings',
              inh: true,
              relpersistence: 'p',
              location: 5566
            }
          },
          targetList: [
            {
              ResTarget: {
                name: 'stuff',
                val: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 10
                      }
                    },
                    location: 5588
                  }
                },
                location: 5580
              }
            }
          ]
        }
      },
      stmt_location: 5558,
      stmt_len: 32
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'V',
          typeName: [
            {
              String: {
                str: 'things'
              }
            }
          ],
          name: 'meow',
          behavior: 0
        }
      },
      stmt_location: 5591,
      stmt_len: 45
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'domtab',
              inh: true,
              relpersistence: 'p',
              location: 5688
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'col1',
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
                    location: 5701
                  }
                },
                is_local: true,
                location: 5696
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 5637,
      stmt_len: 72
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dom'
              }
            }
          ],
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
              location: 5732
            }
          }
        }
      },
      stmt_location: 5710,
      stmt_len: 29
    }
  },
  {
    RawStmt: {
      stmt: {
        ViewStmt: {
          view: {
            RangeVar: {
              relname: 'domview',
              inh: true,
              relpersistence: 'p',
              location: 5753
            }
          },
          query: {
            SelectStmt: {
              targetList: [
                {
                  ResTarget: {
                    val: {
                      TypeCast: {
                        arg: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'col1'
                                }
                              }
                            ],
                            location: 5776
                          }
                        },
                        typeName: {
                          TypeName: {
                            names: [
                              {
                                String: {
                                  str: 'dom'
                                }
                              }
                            ],
                            typemod: -1,
                            location: 5784
                          }
                        },
                        location: 5771
                      }
                    },
                    location: 5771
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'domtab',
                    inh: true,
                    relpersistence: 'p',
                    location: 5794
                  }
                }
              ],
              op: 0
            }
          },
          withCheckOption: 0
        }
      },
      stmt_location: 5740,
      stmt_len: 60
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domtab',
              inh: true,
              relpersistence: 'p',
              location: 5814
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col1',
                location: 5822
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
                        Null: {}
                      },
                      location: 5836
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
      stmt_location: 5801,
      stmt_len: 40
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domtab',
              inh: true,
              relpersistence: 'p',
              location: 5855
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col1',
                location: 5863
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
                        Integer: {
                          ival: 5
                        }
                      },
                      location: 5877
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
      stmt_location: 5842,
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
                        A_Star: {}
                      }
                    ],
                    location: 5888
                  }
                },
                location: 5888
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domview',
                inh: true,
                relpersistence: 'p',
                location: 5895
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 5880,
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'O',
          typeName: [
            {
              String: {
                str: 'dom'
              }
            }
          ],
          behavior: 0
        }
      },
      stmt_location: 5903,
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
                    location: 5943
                  }
                },
                location: 5943
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domview',
                inh: true,
                relpersistence: 'p',
                location: 5950
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 5935,
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'N',
          typeName: [
            {
              String: {
                str: 'dom'
              }
            }
          ],
          behavior: 0
        }
      },
      stmt_location: 5958,
      stmt_len: 40
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
                    location: 6007
                  }
                },
                location: 6007
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domview',
                inh: true,
                relpersistence: 'p',
                location: 6014
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 5999,
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'dom'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'domchkgt6',
              location: 6045,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 6072
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 6
                        }
                      },
                      location: 6080
                    }
                  },
                  location: 6078
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 6022,
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
                    location: 6091
                  }
                },
                location: 6091
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domview',
                inh: true,
                relpersistence: 'p',
                location: 6098
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6083,
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'X',
          typeName: [
            {
              String: {
                str: 'dom'
              }
            }
          ],
          name: 'domchkgt6',
          behavior: 0
        }
      },
      stmt_location: 6106,
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
                    location: 6175
                  }
                },
                location: 6175
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domview',
                inh: true,
                relpersistence: 'p',
                location: 6182
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6167,
      stmt_len: 22
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'ddef1'
                    }
                  }
                ],
                typemod: -1,
                location: 6215
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 6190,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'ddef2'
                    }
                  }
                ],
                typemod: -1,
                location: 6243
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 6230,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'ddef3'
                    }
                  }
                ],
                typemod: -1,
                location: 6271
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 6258,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'ddef4'
                    }
                  }
                ],
                typemod: -1,
                location: 6299
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 6286,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'ddef5'
                    }
                  }
                ],
                typemod: -1,
                location: 6327
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 6314,
      stmt_len: 27
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
                  str: 'ddef4_seq'
                }
              }
            ]
          ],
          removeType: 33,
          behavior: 0
        }
      },
      stmt_location: 6342,
      stmt_len: 24
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'vchar4'
              }
            }
          ],
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
                    str: 'varchar'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 4
                      }
                    },
                    location: 6427
                  }
                }
              ],
              typemod: -1,
              location: 6419
            }
          }
        }
      },
      stmt_location: 6367,
      stmt_len: 62
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dinter'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'vchar4'
                  }
                }
              ],
              typemod: -1,
              location: 6452
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 6459,
                raw_expr: {
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
                      FuncCall: {
                        funcname: [
                          {
                            String: {
                              str: 'pg_catalog'
                            }
                          },
                          {
                            String: {
                              str: 'substring'
                            }
                          }
                        ],
                        args: [
                          {
                            ColumnRef: {
                              fields: [
                                {
                                  String: {
                                    str: 'value'
                                  }
                                }
                              ],
                              location: 6476
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 1
                                }
                              },
                              location: 6483
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 1
                                }
                              },
                              location: 6486
                            }
                          }
                        ],
                        location: 6466
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'x'
                          }
                        },
                        location: 6491
                      }
                    },
                    location: 6489
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 6430,
      stmt_len: 65
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'dtop'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'dinter'
                  }
                }
              ],
              typemod: -1,
              location: 6516
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 6523,
                raw_expr: {
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
                      FuncCall: {
                        funcname: [
                          {
                            String: {
                              str: 'pg_catalog'
                            }
                          },
                          {
                            String: {
                              str: 'substring'
                            }
                          }
                        ],
                        args: [
                          {
                            ColumnRef: {
                              fields: [
                                {
                                  String: {
                                    str: 'value'
                                  }
                                }
                              ],
                              location: 6540
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 2
                                }
                              },
                              location: 6547
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 1
                                }
                              },
                              location: 6550
                            }
                          }
                        ],
                        location: 6530
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: '1'
                          }
                        },
                        location: 6555
                      }
                    },
                    location: 6553
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 6496,
      stmt_len: 63
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'x123'
                          }
                        },
                        location: 6569
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dtop'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 6577
                      }
                    },
                    location: 6575
                  }
                },
                location: 6569
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6560,
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'x1234'
                          }
                        },
                        location: 6590
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dtop'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 6599
                      }
                    },
                    location: 6597
                  }
                },
                location: 6590
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6582,
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'y1234'
                          }
                        },
                        location: 6649
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dtop'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 6658
                      }
                    },
                    location: 6656
                  }
                },
                location: 6649
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6604,
      stmt_len: 58
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'y123'
                          }
                        },
                        location: 6679
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dtop'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 6687
                      }
                    },
                    location: 6685
                  }
                },
                location: 6679
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6663,
      stmt_len: 28
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'yz23'
                          }
                        },
                        location: 6708
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dtop'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 6716
                      }
                    },
                    location: 6714
                  }
                },
                location: 6708
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6692,
      stmt_len: 28
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
                  TypeCast: {
                    arg: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'xz23'
                          }
                        },
                        location: 6737
                      }
                    },
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'dtop'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 6745
                      }
                    },
                    location: 6743
                  }
                },
                location: 6737
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 6721,
      stmt_len: 28
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'dtest',
              inh: true,
              relpersistence: 't',
              location: 6778
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
                          str: 'dtop'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 6787
                  }
                },
                is_local: true,
                location: 6784
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 6750,
      stmt_len: 42
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'dtest',
              inh: true,
              relpersistence: 'p',
              location: 6807
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'x123'
                        }
                      },
                      location: 6820
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
      stmt_location: 6793,
      stmt_len: 34
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'dtest',
              inh: true,
              relpersistence: 'p',
              location: 6841
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'x1234'
                        }
                      },
                      location: 6854
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
      stmt_location: 6828,
      stmt_len: 34
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'dtest',
              inh: true,
              relpersistence: 'p',
              location: 6903
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'y1234'
                        }
                      },
                      location: 6916
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
      stmt_location: 6863,
      stmt_len: 61
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'dtest',
              inh: true,
              relpersistence: 'p',
              location: 6965
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'y123'
                        }
                      },
                      location: 6978
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
      stmt_location: 6925,
      stmt_len: 60
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'dtest',
              inh: true,
              relpersistence: 'p',
              location: 7007
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'yz23'
                        }
                      },
                      location: 7020
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
      stmt_location: 6986,
      stmt_len: 41
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'dtest',
              inh: true,
              relpersistence: 'p',
              location: 7049
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'xz23'
                        }
                      },
                      location: 7062
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
      stmt_location: 7028,
      stmt_len: 41
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
                  str: 'dtest'
                }
              }
            ]
          ],
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 7070,
      stmt_len: 26
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'vchar4'
                    }
                  }
                ],
                typemod: -1,
                location: 7110
              }
            }
          ],
          removeType: 12,
          behavior: 1
        }
      },
      stmt_location: 7097,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'str_domain'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'text'
                  }
                }
              ],
              typemod: -1,
              location: 7312
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 1,
                location: 7317
              }
            }
          ]
        }
      },
      stmt_location: 7125,
      stmt_len: 200
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'domain_test',
              inh: true,
              relpersistence: 'p',
              location: 7341
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'a',
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
                    location: 7356
                  }
                },
                is_local: true,
                location: 7354
              }
            },
            {
              ColumnDef: {
                colname: 'b',
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
                    location: 7363
                  }
                },
                is_local: true,
                location: 7361
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 7326,
      stmt_len: 41
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domain_test',
              inh: true,
              relpersistence: 'p',
              location: 7382
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
                          ival: 1
                        }
                      },
                      location: 7402
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 2
                        }
                      },
                      location: 7405
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
      stmt_location: 7368,
      stmt_len: 39
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'domain_test',
              inh: true,
              relpersistence: 'p',
              location: 7421
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
                          ival: 1
                        }
                      },
                      location: 7441
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 2
                        }
                      },
                      location: 7444
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
      stmt_location: 7408,
      stmt_len: 38
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterTableStmt: {
          relation: {
            RangeVar: {
              relname: 'domain_test',
              inh: true,
              relpersistence: 'p',
              location: 7476
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 0,
                def: {
                  ColumnDef: {
                    colname: 'c',
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'str_domain'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 7501
                      }
                    },
                    is_local: true,
                    location: 7499
                  }
                },
                behavior: 0
              }
            }
          ],
          relkind: 37
        }
      },
      stmt_location: 7447,
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'str_domain2'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'text'
                  }
                }
              ],
              typemod: -1,
              location: 7543
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 7548,
                raw_expr: {
                  A_Expr: {
                    kind: 0,
                    name: [
                      {
                        String: {
                          str: '<>'
                        }
                      }
                    ],
                    lexpr: {
                      ColumnRef: {
                        fields: [
                          {
                            String: {
                              str: 'value'
                            }
                          }
                        ],
                        location: 7555
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'foo'
                          }
                        },
                        location: 7564
                      }
                    },
                    location: 7561
                  }
                },
                initially_valid: true
              }
            },
            {
              Constraint: {
                contype: 2,
                location: 7571,
                raw_expr: {
                  A_Const: {
                    val: {
                      String: {
                        str: 'foo'
                      }
                    },
                    location: 7579
                  }
                }
              }
            }
          ]
        }
      },
      stmt_location: 7512,
      stmt_len: 72
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterTableStmt: {
          relation: {
            RangeVar: {
              relname: 'domain_test',
              inh: true,
              relpersistence: 'p',
              location: 7614
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 0,
                def: {
                  ColumnDef: {
                    colname: 'd',
                    typeName: {
                      TypeName: {
                        names: [
                          {
                            String: {
                              str: 'str_domain2'
                            }
                          }
                        ],
                        typemod: -1,
                        location: 7639
                      }
                    },
                    is_local: true,
                    location: 7637
                  }
                },
                behavior: 0
              }
            }
          ],
          relkind: 37
        }
      },
      stmt_location: 7585,
      stmt_len: 65
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'pos_int'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              typemod: -1,
              location: 7787
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 7792,
                raw_expr: {
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
                              str: 'value'
                            }
                          }
                        ],
                        location: 7799
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 0
                          }
                        },
                        location: 7807
                      }
                    },
                    location: 7805
                  }
                },
                initially_valid: true
              }
            },
            {
              Constraint: {
                contype: 1,
                location: 7810
              }
            }
          ]
        }
      },
      stmt_location: 7651,
      stmt_len: 167
    }
  },
  {
    RawStmt: {
      stmt: {
        ExecuteStmt: {
          name: 's1',
          params: [
            {
              A_Const: {
                val: {
                  Integer: {
                    ival: 10
                  }
                },
                location: 7883
              }
            }
          ]
        }
      },
      stmt_location: 7870,
      stmt_len: 16
    }
  },
  {
    RawStmt: {
      stmt: {
        ExecuteStmt: {
          name: 's1',
          params: [
            {
              A_Const: {
                val: {
                  Integer: {
                    ival: 0
                  }
                },
                location: 7899
              }
            }
          ]
        }
      },
      stmt_location: 7887,
      stmt_len: 14
    }
  },
  {
    RawStmt: {
      stmt: {
        ExecuteStmt: {
          name: 's1',
          params: [
            {
              A_Const: {
                val: {
                  Null: {}
                },
                location: 7929
              }
            }
          ]
        }
      },
      stmt_location: 7902,
      stmt_len: 32
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateFunctionStmt: {
          funcname: [
            {
              String: {
                str: 'doubledecrement'
              }
            }
          ],
          parameters: [
            {
              FunctionParameter: {
                name: 'p1',
                argType: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'pos_int'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 8109
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
                    str: 'pos_int'
                  }
                }
              ],
              typemod: -1,
              location: 8126
            }
          },
          options: [
            {
              DefElem: {
                defname: 'as',
                arg: [
                  {
                    String: {
                      str: '\ndeclare v pos_int;\nbegin\n    return p1;\nend'
                    }
                  }
                ],
                defaction: 0,
                location: 8134
              }
            },
            {
              DefElem: {
                defname: 'language',
                arg: {
                  String: {
                    str: 'plpgsql'
                  }
                },
                defaction: 0,
                location: 8186
              }
            }
          ]
        }
      },
      stmt_location: 7935,
      stmt_len: 267
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
                          str: 'doubledecrement'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 3
                            }
                          },
                          location: 8228
                        }
                      }
                    ],
                    location: 8212
                  }
                },
                location: 8212
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 8203,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateFunctionStmt: {
          replace: true,
          funcname: [
            {
              String: {
                str: 'doubledecrement'
              }
            }
          ],
          parameters: [
            {
              FunctionParameter: {
                name: 'p1',
                argType: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'pos_int'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 8323
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
                    str: 'pos_int'
                  }
                }
              ],
              typemod: -1,
              location: 8340
            }
          },
          options: [
            {
              DefElem: {
                defname: 'as',
                arg: [
                  {
                    String: {
                      str:
                        '\ndeclare v pos_int := 0;\nbegin\n    return p1;\nend'
                    }
                  }
                ],
                defaction: 0,
                location: 8348
              }
            },
            {
              DefElem: {
                defname: 'language',
                arg: {
                  String: {
                    str: 'plpgsql'
                  }
                },
                defaction: 0,
                location: 8405
              }
            }
          ]
        }
      },
      stmt_location: 8231,
      stmt_len: 190
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
                          str: 'doubledecrement'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 3
                            }
                          },
                          location: 8447
                        }
                      }
                    ],
                    location: 8431
                  }
                },
                location: 8431
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 8422,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateFunctionStmt: {
          replace: true,
          funcname: [
            {
              String: {
                str: 'doubledecrement'
              }
            }
          ],
          parameters: [
            {
              FunctionParameter: {
                name: 'p1',
                argType: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'pos_int'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 8535
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
                    str: 'pos_int'
                  }
                }
              ],
              typemod: -1,
              location: 8552
            }
          },
          options: [
            {
              DefElem: {
                defname: 'as',
                arg: [
                  {
                    String: {
                      str:
                        '\ndeclare v pos_int := 1;\nbegin\n    v := p1 - 1;\n    return v - 1;\nend'
                    }
                  }
                ],
                defaction: 0,
                location: 8560
              }
            },
            {
              DefElem: {
                defname: 'language',
                arg: {
                  String: {
                    str: 'plpgsql'
                  }
                },
                defaction: 0,
                location: 8637
              }
            }
          ]
        }
      },
      stmt_location: 8450,
      stmt_len: 203
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
                          str: 'doubledecrement'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Null: {}
                          },
                          location: 8679
                        }
                      }
                    ],
                    location: 8663
                  }
                },
                location: 8663
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 8654,
      stmt_len: 30
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
                          str: 'doubledecrement'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 0
                            }
                          },
                          location: 8729
                        }
                      }
                    ],
                    location: 8713
                  }
                },
                location: 8713
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 8685,
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
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'doubledecrement'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 1
                            }
                          },
                          location: 8776
                        }
                      }
                    ],
                    location: 8760
                  }
                },
                location: 8760
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 8732,
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
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'doubledecrement'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 2
                            }
                          },
                          location: 8830
                        }
                      }
                    ],
                    location: 8814
                  }
                },
                location: 8814
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 8779,
      stmt_len: 53
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
                          str: 'doubledecrement'
                        }
                      }
                    ],
                    args: [
                      {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 3
                            }
                          },
                          location: 8875
                        }
                      }
                    ],
                    location: 8859
                  }
                },
                location: 8859
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 8833,
      stmt_len: 44
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'posint'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'int4'
                  }
                }
              ],
              typemod: -1,
              location: 8971
            }
          }
        }
      },
      stmt_location: 8878,
      stmt_len: 97
    }
  },
  {
    RawStmt: {
      stmt: {
        CompositeTypeStmt: {
          typevar: {
            RangeVar: {
              relname: 'ddtest1',
              relpersistence: 'p',
              location: 9067
            }
          },
          coldeflist: [
            {
              ColumnDef: {
                colname: 'f1',
                typeName: {
                  TypeName: {
                    names: [
                      {
                        String: {
                          str: 'posint'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 9082
                  }
                },
                is_local: true,
                location: 9079
              }
            }
          ]
        }
      },
      stmt_location: 8976,
      stmt_len: 113
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'ddtest2',
              inh: true,
              relpersistence: 'p',
              location: 9104
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
                          str: 'ddtest1'
                        }
                      }
                    ],
                    typemod: -1,
                    location: 9115
                  }
                },
                is_local: true,
                location: 9112
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 9090,
      stmt_len: 33
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'ddtest2',
              inh: true,
              relpersistence: 'p',
              location: 9137
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    RowExpr: {
                      args: [
                        {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: -1
                              }
                            },
                            location: 9156
                          }
                        }
                      ],
                      row_format: 0,
                      location: 9152
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
      stmt_location: 9124,
      stmt_len: 36
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'posint'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'c1',
              location: 9186,
              raw_expr: {
                A_Expr: {
                  kind: 0,
                  name: [
                    {
                      String: {
                        str: '>='
                      }
                    }
                  ],
                  lexpr: {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'value'
                          }
                        }
                      ],
                      location: 9206
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 9215
                    }
                  },
                  location: 9212
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 9161,
      stmt_len: 56
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
                  str: 'ddtest2'
                }
              }
            ]
          ],
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 9218,
      stmt_len: 19
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'ddtest2',
              inh: true,
              relpersistence: 'p',
              location: 9253
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
                          str: 'ddtest1'
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
                    ],
                    location: 9264
                  }
                },
                is_local: true,
                location: 9261
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 9238,
      stmt_len: 36
    }
  },
  {
    RawStmt: {
      stmt: {
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'ddtest2',
              inh: true,
              relpersistence: 'p',
              location: 9288
            }
          },
          selectStmt: {
            SelectStmt: {
              valuesLists: [
                [
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: '{(-1)}'
                        }
                      },
                      location: 9303
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
      stmt_location: 9275,
      stmt_len: 37
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'posint'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'c1',
              location: 9338,
              raw_expr: {
                A_Expr: {
                  kind: 0,
                  name: [
                    {
                      String: {
                        str: '>='
                      }
                    }
                  ],
                  lexpr: {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'value'
                          }
                        }
                      ],
                      location: 9358
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 9367
                    }
                  },
                  location: 9364
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 9313,
      stmt_len: 56
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'posint'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'c1',
              location: 9395,
              raw_expr: {
                A_Expr: {
                  kind: 0,
                  name: [
                    {
                      String: {
                        str: '>='
                      }
                    }
                  ],
                  lexpr: {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'value'
                          }
                        }
                      ],
                      location: 9415
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 9424
                    }
                  },
                  location: 9421
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 9370,
      stmt_len: 56
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'posint2'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'posint'
                  }
                }
              ],
              typemod: -1,
              location: 9453
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 9460,
                raw_expr: {
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
                      A_Expr: {
                        kind: 0,
                        name: [
                          {
                            String: {
                              str: '%'
                            }
                          }
                        ],
                        lexpr: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'value'
                                }
                              }
                            ],
                            location: 9467
                          }
                        },
                        rexpr: {
                          A_Const: {
                            val: {
                              Integer: {
                                ival: 2
                              }
                            },
                            location: 9475
                          }
                        },
                        location: 9473
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 0
                          }
                        },
                        location: 9479
                      }
                    },
                    location: 9477
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 9427,
      stmt_len: 54
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'posint'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'c2',
              location: 9507,
              raw_expr: {
                A_Expr: {
                  kind: 0,
                  name: [
                    {
                      String: {
                        str: '>='
                      }
                    }
                  ],
                  lexpr: {
                    ColumnRef: {
                      fields: [
                        {
                          String: {
                            str: 'value'
                          }
                        }
                      ],
                      location: 9527
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 10
                        }
                      },
                      location: 9536
                    }
                  },
                  location: 9533
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 9482,
      stmt_len: 57
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'posint'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'c2',
              location: 9573,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 9593
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 9601
                    }
                  },
                  location: 9599
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 9540,
      stmt_len: 63
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
                  str: 'ddtest2'
                }
              }
            ]
          ],
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 9604,
      stmt_len: 25
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'ddtest1'
                    }
                  }
                ],
                typemod: -1,
                location: 9641
              }
            }
          ],
          removeType: 45,
          behavior: 0
        }
      },
      stmt_location: 9630,
      stmt_len: 18
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'posint'
                    }
                  }
                ],
                typemod: -1,
                location: 9662
              }
            }
          ],
          removeType: 12,
          behavior: 1
        }
      },
      stmt_location: 9649,
      stmt_len: 27
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'mynums'
              }
            }
          ],
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
                    str: 'numeric'
                  }
                }
              ],
              typmods: [
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 4
                      }
                    },
                    location: 9710
                  }
                },
                {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 2
                      }
                    },
                    location: 9712
                  }
                }
              ],
              typemod: -1,
              arrayBounds: [
                {
                  Integer: {
                    ival: 1
                  }
                }
              ],
              location: 9702
            }
          }
        }
      },
      stmt_location: 9677,
      stmt_len: 40
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'mynums2'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'mynums'
                  }
                }
              ],
              typemod: -1,
              location: 9744
            }
          }
        }
      },
      stmt_location: 9718,
      stmt_len: 32
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'orderedpair'
              }
            }
          ],
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
              arrayBounds: [
                {
                  Integer: {
                    ival: 2
                  }
                }
              ],
              location: 9781
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 9788,
                raw_expr: {
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
                      A_Indirection: {
                        arg: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'value'
                                }
                              }
                            ],
                            location: 9795
                          }
                        },
                        indirection: [
                          {
                            A_Indices: {
                              uidx: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 1
                                    }
                                  },
                                  location: 9801
                                }
                              }
                            }
                          }
                        ]
                      }
                    },
                    rexpr: {
                      A_Indirection: {
                        arg: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'value'
                                }
                              }
                            ],
                            location: 9806
                          }
                        },
                        indirection: [
                          {
                            A_Indices: {
                              uidx: {
                                A_Const: {
                                  val: {
                                    Integer: {
                                      ival: 2
                                    }
                                  },
                                  location: 9812
                                }
                              }
                            }
                          }
                        ]
                      }
                    },
                    location: 9804
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 9751,
      stmt_len: 64
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'di'
              }
            }
          ],
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
              location: 9837
            }
          }
        }
      },
      stmt_location: 9816,
      stmt_len: 24
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'C',
          typeName: [
            {
              String: {
                str: 'di'
              }
            }
          ],
          def: {
            Constraint: {
              contype: 4,
              conname: 'pos',
              location: 9862,
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ],
                      location: 9884
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 0
                        }
                      },
                      location: 9892
                    }
                  },
                  location: 9890
                }
              },
              initially_valid: true
            }
          },
          behavior: 0
        }
      },
      stmt_location: 9841,
      stmt_len: 53
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'inotnull'
              }
            }
          ],
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
              location: 9919
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 9925,
                raw_expr: {
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'sql_is_distinct_from'
                        }
                      }
                    ],
                    args: [
                      {
                        ColumnRef: {
                          fields: [
                            {
                              String: {
                                str: 'value'
                              }
                            }
                          ],
                          location: 9953
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Null: {}
                          },
                          location: 9960
                        }
                      }
                    ],
                    location: 9932
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 9895,
      stmt_len: 71
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'inotnull'
                    }
                  }
                ],
                typemod: -1,
                location: 9980
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 9967,
      stmt_len: 21
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'testdomain1'
              }
            }
          ],
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
              location: 10019
            }
          }
        }
      },
      stmt_location: 9989,
      stmt_len: 33
    }
  },
  {
    RawStmt: {
      stmt: {
        RenameStmt: {
          renameType: 12,
          relationType: 0,
          object: [
            {
              String: {
                str: 'testdomain1'
              }
            }
          ],
          newname: 'testdomain2',
          behavior: 0
        }
      },
      stmt_location: 10023,
      stmt_len: 47
    }
  },
  {
    RawStmt: {
      stmt: {
        RenameStmt: {
          renameType: 45,
          relationType: 0,
          object: [
            {
              String: {
                str: 'testdomain2'
              }
            }
          ],
          newname: 'testdomain3',
          behavior: 0
        }
      },
      stmt_location: 10071,
      stmt_len: 45
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'testdomain3'
                    }
                  }
                ],
                typemod: -1,
                location: 10156
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 10117,
      stmt_len: 50
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'testdomain1'
              }
            }
          ],
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
              location: 10198
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                conname: 'unsigned',
                location: 10202,
                raw_expr: {
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
                              str: 'value'
                            }
                          }
                        ],
                        location: 10229
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          Integer: {
                            ival: 0
                          }
                        },
                        location: 10237
                      }
                    },
                    location: 10235
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 10168,
      stmt_len: 71
    }
  },
  {
    RawStmt: {
      stmt: {
        RenameStmt: {
          renameType: 13,
          relationType: 0,
          object: [
            {
              String: {
                str: 'testdomain1'
              }
            }
          ],
          subname: 'unsigned',
          newname: 'unsigned_foo',
          behavior: 0
        }
      },
      stmt_location: 10240,
      stmt_len: 68
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterDomainStmt: {
          subtype: 'X',
          typeName: [
            {
              String: {
                str: 'testdomain1'
              }
            }
          ],
          name: 'unsigned_foo',
          behavior: 0
        }
      },
      stmt_location: 10309,
      stmt_len: 54
    }
  },
  {
    RawStmt: {
      stmt: {
        DropStmt: {
          objects: [
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'testdomain1'
                    }
                  }
                ],
                typemod: -1,
                location: 10377
              }
            }
          ],
          removeType: 12,
          behavior: 0
        }
      },
      stmt_location: 10364,
      stmt_len: 24
    }
  }
];
