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
              typemod: -1
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
          objtype: 'OBJECT_DOMAIN',
          object: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'domaindoptest'
                  }
                }
              ],
              typemod: -1
            }
          },
          comment: 'About to drop this..'
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_CASCADE'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_CASCADE'
        }
      },
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
                    }
                  }
                }
              ],
              typemod: -1
            }
          }
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
                    kind: 'AEXPR_OF',
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
                                  }
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
                                  typemod: -1
                                }
                              }
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 7
                                }
                              }
                            }
                          }
                        ]
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
                          typemod: -1
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
                    kind: 'AEXPR_OF',
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
                                  }
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
                                  typemod: -1
                                }
                              }
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 7
                                }
                              }
                            }
                          }
                        ]
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
                          typemod: -1
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
                    kind: 'AEXPR_OF',
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
                                  }
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
                                  typemod: -1
                                }
                              }
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
                                  }
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
                                  typemod: -1
                                }
                              }
                            }
                          }
                        ]
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
                          typemod: -1
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
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
              ]
            }
          }
        }
      },
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
                    }
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
              ]
            }
          }
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
            {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'domainint4arr'
                    }
                  }
                ],
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
              ]
            }
          }
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                    }
                  }
                }
              ],
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_NOTNULL'
              }
            }
          ]
        }
      },
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
                    }
                  }
                }
              ],
              typemod: -1
            }
          }
        }
      },
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
                    }
                  }
                }
              ],
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_NOTNULL'
              }
            },
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                raw_expr: {
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
                                    str: 'value'
                                  }
                                }
                              ]
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'a'
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
                                    str: 'value'
                                  }
                                }
                              ]
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'c'
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
                                    str: 'value'
                                  }
                                }
                              ]
                            }
                          },
                          rexpr: {
                            A_Const: {
                              val: {
                                String: {
                                  str: 'd'
                                }
                              }
                            }
                          }
                        }
                      }
                    ]
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_NULL'
                    }
                  }
                ]
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_NOTNULL'
                    }
                  }
                ]
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_CHECK',
                      raw_expr: {
                        A_Expr: {
                          kind: 'AEXPR_IN',
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
                              ]
                            }
                          },
                          rexpr: [
                            {
                              A_Const: {
                                val: {
                                  String: {
                                    str: 'c'
                                  }
                                }
                              }
                            },
                            {
                              A_Const: {
                                val: {
                                  String: {
                                    str: 'd'
                                  }
                                }
                              }
                            }
                          ]
                        }
                      },
                      initially_valid: true
                    }
                  }
                ]
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                        String: {
                          str: 'a'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
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
                        String: {
                          str: 'a'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
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
                        String: {
                          str: 'a'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'a'
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
                        Null: {}
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
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
                        String: {
                          str: 'a'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
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
                        String: {
                          str: 'a'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
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
                        String: {
                          str: 'a'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'b'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'c'
                        }
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        Null: {}
                      }
                    }
                  },
                  {
                    A_Const: {
                      val: {
                        String: {
                          str: 'd'
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
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'nulltest',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
                        }
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
                        typemod: -1
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
                        }
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
                        typemod: -1
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
                            }
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
                            typemod: -1
                          }
                        }
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
                        typemod: -1
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
                        ]
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
                        typemod: -1
                      }
                    }
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'nulltest',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_DEFAULT',
                raw_expr: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 3
                      }
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_DEFAULT',
                raw_expr: {
                  A_Const: {
                    val: {
                      String: {
                        str: '12'
                      }
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_DEFAULT',
                raw_expr: {
                  A_Const: {
                    val: {
                      Integer: {
                        ival: 5
                      }
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
              relpersistence: 'p'
            }
          }
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_DEFAULT',
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
                          }
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_NOTNULL'
              }
            },
            {
              Constraint: {
                contype: 'CONSTR_DEFAULT',
                raw_expr: {
                  A_Const: {
                    val: {
                      String: {
                        str: '12.12'
                      }
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_PRIMARY'
                    }
                  }
                ]
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_NOTNULL'
                    }
                  },
                  {
                    Constraint: {
                      contype: 'CONSTR_DEFAULT',
                      raw_expr: {
                        A_Const: {
                          val: {
                            Null: {}
                          }
                        }
                      }
                    }
                  }
                ]
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_DEFAULT',
                      raw_expr: {
                        A_Const: {
                          val: {
                            String: {
                              str: '88'
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_DEFAULT',
                      raw_expr: {
                        A_Const: {
                          val: {
                            Integer: {
                              ival: 8000
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col4'
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
              relpersistence: 'p'
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 'AT_ColumnDefault',
                name: 'col5',
                behavior: 'DROP_RESTRICT'
              }
            }
          ],
          relkind: 'OBJECT_TABLE'
        }
      },
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
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
              relpersistence: 'p'
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 'AT_ColumnDefault',
                name: 'col5',
                def: {
                  A_Const: {
                    val: {
                      Null: {}
                    }
                  }
                },
                behavior: 'DROP_RESTRICT'
              }
            }
          ],
          relkind: 'OBJECT_TABLE'
        }
      },
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
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col4'
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
              relpersistence: 'p'
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 'AT_ColumnDefault',
                name: 'col5',
                behavior: 'DROP_RESTRICT'
              }
            }
          ],
          relkind: 'OBJECT_TABLE'
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
              relname: 'defaulttest',
              inh: true,
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'defaulttest',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_CASCADE'
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
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
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
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
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
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
                    }
                  }
                }
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
        AlterDomainStmt: {
          subtype: 'N',
          typeName: [
            {
              String: {
                str: 'dnotnulltest'
              }
            }
          ],
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
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
                    }
                  }
                }
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_CASCADE'
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domdeftest',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
              }
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domdeftest',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domdeftest',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                          ival: 2
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
              contype: 'CONSTR_CHECK',
              conname: 't',
              raw_expr: {
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
                            str: 'value'
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
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              contype: 'CONSTR_CHECK',
              conname: 't',
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ]
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 34
                        }
                      }
                    }
                  }
                }
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              contype: 'CONSTR_CHECK',
              raw_expr: {
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
                            str: 'value'
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
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
                          ival: -5
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
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                          ival: 5
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
                          ival: -5
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
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
          behavior: 'DROP_RESTRICT',
          missing_ok: true
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'stuff'
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
              contype: 'CONSTR_CHECK',
              conname: 'meow',
              raw_expr: {
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
                            str: 'value'
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
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              contype: 'CONSTR_CHECK',
              conname: 'meow',
              raw_expr: {
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
                            str: 'value'
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
              skip_validation: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
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
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              relpersistence: 'p'
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
                            ]
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
                            typemod: -1
                          }
                        }
                      }
                    }
                  }
                }
              ],
              fromClause: [
                {
                  RangeVar: {
                    relname: 'domtab',
                    inh: true,
                    relpersistence: 'p'
                  }
                }
              ],
              op: 'SETOP_NONE'
            }
          },
          withCheckOption: 0
        }
      },
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
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col1'
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
              relpersistence: 'p'
            }
          },
          cols: [
            {
              ResTarget: {
                name: 'col1'
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
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domview',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
          behavior: 'DROP_RESTRICT'
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
                relname: 'domview',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
                    ]
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'domview',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
              contype: 'CONSTR_CHECK',
              conname: 'domchkgt6',
              raw_expr: {
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
                            str: 'value'
                          }
                        }
                      ]
                    }
                  },
                  rexpr: {
                    A_Const: {
                      val: {
                        Integer: {
                          ival: 6
                        }
                      }
                    }
                  }
                }
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
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
                relname: 'domview',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
          behavior: 'DROP_RESTRICT'
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
                relname: 'domview',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          op: 'SETOP_NONE'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
          removeType: 'OBJECT_SEQUENCE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                    }
                  }
                }
              ],
              typemod: -1
            }
          }
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                raw_expr: {
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
                              ]
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
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'x'
                          }
                        }
                      }
                    }
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                raw_expr: {
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
                              ]
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
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: '1'
                          }
                        }
                      }
                    }
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
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
                        }
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
                        typemod: -1
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
                        }
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
                        typemod: -1
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
                        }
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
                        typemod: -1
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
                        }
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
                        typemod: -1
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
                        }
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
                        typemod: -1
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
                        }
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
                        typemod: -1
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
                          str: 'dtop'
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
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
                        String: {
                          str: 'x123'
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
                        String: {
                          str: 'x1234'
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
                        String: {
                          str: 'y1234'
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
                        String: {
                          str: 'y123'
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
                        String: {
                          str: 'yz23'
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
                        String: {
                          str: 'xz23'
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
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_CASCADE'
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_NOTNULL'
              }
            }
          ]
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
                ]
              ],
              op: 'SETOP_NONE'
            }
          },
          override: 'OVERRIDING_NOT_SET'
        }
      },
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
              relpersistence: 'p'
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 'AT_AddColumn',
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
                        typemod: -1
                      }
                    },
                    is_local: true
                  }
                },
                behavior: 'DROP_RESTRICT'
              }
            }
          ],
          relkind: 'OBJECT_TABLE'
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                raw_expr: {
                  A_Expr: {
                    kind: 'AEXPR_OP',
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
                        ]
                      }
                    },
                    rexpr: {
                      A_Const: {
                        val: {
                          String: {
                            str: 'foo'
                          }
                        }
                      }
                    }
                  }
                },
                initially_valid: true
              }
            },
            {
              Constraint: {
                contype: 'CONSTR_DEFAULT',
                raw_expr: {
                  A_Const: {
                    val: {
                      String: {
                        str: 'foo'
                      }
                    }
                  }
                }
              }
            }
          ]
        }
      },
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
              relpersistence: 'p'
            }
          },
          cmds: [
            {
              AlterTableCmd: {
                subtype: 'AT_AddColumn',
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
                        typemod: -1
                      }
                    },
                    is_local: true
                  }
                },
                behavior: 'DROP_RESTRICT'
              }
            }
          ],
          relkind: 'OBJECT_TABLE'
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                raw_expr: {
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
                              str: 'value'
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
                },
                initially_valid: true
              }
            },
            {
              Constraint: {
                contype: 'CONSTR_NOTNULL'
              }
            }
          ]
        }
      },
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
                }
              }
            }
          ]
        }
      },
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
                }
              }
            }
          ]
        }
      },
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
                }
              }
            }
          ]
        }
      },
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
                    typemod: -1
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
                      str: '\ndeclare v pos_int;\nbegin\n    return p1;\nend'
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
                    str: 'plpgsql'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
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
                    typemod: -1
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
                      str:
                        '\ndeclare v pos_int := 0;\nbegin\n    return p1;\nend'
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
                    str: 'plpgsql'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
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
                    typemod: -1
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
                      str:
                        '\ndeclare v pos_int := 1;\nbegin\n    v := p1 - 1;\n    return v - 1;\nend'
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
                    str: 'plpgsql'
                  }
                },
                defaction: 0
              }
            }
          ]
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ]
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              relpersistence: 'p'
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
                            }
                          }
                        }
                      ],
                      row_format: 0
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
              contype: 'CONSTR_CHECK',
              conname: 'c1',
              raw_expr: {
                A_Expr: {
                  kind: 'AEXPR_OP',
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
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
              relpersistence: 'p'
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
                    ]
                  }
                },
                is_local: true
              }
            }
          ],
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
                        String: {
                          str: '{(-1)}'
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
              contype: 'CONSTR_CHECK',
              conname: 'c1',
              raw_expr: {
                A_Expr: {
                  kind: 'AEXPR_OP',
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
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              contype: 'CONSTR_CHECK',
              conname: 'c1',
              raw_expr: {
                A_Expr: {
                  kind: 'AEXPR_OP',
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
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                raw_expr: {
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
                      A_Expr: {
                        kind: 'AEXPR_OP',
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
                            ]
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
                },
                initially_valid: true
              }
            }
          ]
        }
      },
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
              contype: 'CONSTR_CHECK',
              conname: 'c2',
              raw_expr: {
                A_Expr: {
                  kind: 'AEXPR_OP',
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
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              contype: 'CONSTR_CHECK',
              conname: 'c2',
              raw_expr: {
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
                            str: 'value'
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
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_TYPE',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_CASCADE'
        }
      },
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
              typemod: -1,
              arrayBounds: [
                {
                  Integer: {
                    ival: 1
                  }
                }
              ]
            }
          }
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              ]
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                raw_expr: {
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
                      A_Indirection: {
                        arg: {
                          ColumnRef: {
                            fields: [
                              {
                                String: {
                                  str: 'value'
                                }
                              }
                            ]
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
                                  }
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
                            ]
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
                                  }
                                }
                              }
                            }
                          }
                        ]
                      }
                    }
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
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
              typemod: -1
            }
          }
        }
      },
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
              contype: 'CONSTR_CHECK',
              conname: 'pos',
              raw_expr: {
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
                            str: 'value'
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
              },
              initially_valid: true
            }
          },
          behavior: 'DROP_RESTRICT'
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
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
                          ]
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            Null: {}
                          }
                        }
                      }
                    ]
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
              typemod: -1
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
        RenameStmt: {
          renameType: 'OBJECT_DOMAIN',
          relationType: 'OBJECT_ACCESS_METHOD',
          object: [
            {
              String: {
                str: 'testdomain1'
              }
            }
          ],
          newname: 'testdomain2',
          behavior: 'DROP_RESTRICT'
        }
      },
      stmt_len: 47
    }
  },
  {
    RawStmt: {
      stmt: {
        RenameStmt: {
          renameType: 'OBJECT_TYPE',
          relationType: 'OBJECT_ACCESS_METHOD',
          object: [
            {
              String: {
                str: 'testdomain2'
              }
            }
          ],
          newname: 'testdomain3',
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
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
              typemod: -1
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 'CONSTR_CHECK',
                conname: 'unsigned',
                raw_expr: {
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
                              str: 'value'
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
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_len: 71
    }
  },
  {
    RawStmt: {
      stmt: {
        RenameStmt: {
          renameType: 'OBJECT_DOMCONSTRAINT',
          relationType: 'OBJECT_ACCESS_METHOD',
          object: [
            {
              String: {
                str: 'testdomain1'
              }
            }
          ],
          subname: 'unsigned',
          newname: 'unsigned_foo',
          behavior: 'DROP_RESTRICT'
        }
      },
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
          behavior: 'DROP_RESTRICT'
        }
      },
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
                typemod: -1
              }
            }
          ],
          removeType: 'OBJECT_DOMAIN',
          behavior: 'DROP_RESTRICT'
        }
      },
      stmt_len: 24
    }
  }
];
