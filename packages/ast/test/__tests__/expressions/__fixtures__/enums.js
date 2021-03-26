export const enums = [
  {
    RawStmt: {
      stmt: {
        CreateEnumStmt: {
          typeName: [
            {
              String: {
                str: 'rainbow'
              }
            }
          ],
          vals: [
            {
              String: {
                str: 'red'
              }
            },
            {
              String: {
                str: 'orange'
              }
            },
            {
              String: {
                str: 'yellow'
              }
            },
            {
              String: {
                str: 'green'
              }
            },
            {
              String: {
                str: 'blue'
              }
            },
            {
              String: {
                str: 'purple'
              }
            }
          ]
        }
      },
      stmt_len: 82
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateEnumStmt: {
          typeName: [
            {
              String: {
                str: 'planets'
              }
            }
          ],
          vals: [
            {
              String: {
                str: 'venus'
              }
            },
            {
              String: {
                str: 'earth'
              }
            },
            {
              String: {
                str: 'mars'
              }
            }
          ]
        }
      },
      stmt_len: 57
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterEnumStmt: {
          typeName: [
            {
              String: {
                str: 'planets'
              }
            }
          ],
          newVal: 'uranus',
          newValIsAfter: true
        }
      },
      stmt_len: 38
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterEnumStmt: {
          typeName: [
            {
              String: {
                str: 'planets'
              }
            }
          ],
          newVal: 'mercury',
          newValNeighbor: 'venus'
        }
      },
      stmt_len: 54
    }
  },
  {
    RawStmt: {
      stmt: {
        AlterEnumStmt: {
          typeName: [
            {
              String: {
                str: 'planets'
              }
            }
          ],
          newVal: 'neptune',
          newValNeighbor: 'uranus',
          newValIsAfter: true
        }
      },
      stmt_len: 54
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
                          str: 'enum_last'
                        }
                      }
                    ],
                    args: [
                      {
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
                                    str: 'planets'
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
                }
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
        CreateEnumStmt: {
          typeName: [
            {
              String: {
                str: 'insenum'
              }
            }
          ],
          vals: [
            {
              String: {
                str: 'L1'
              }
            },
            {
              String: {
                str: 'L2'
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
        InsertStmt: {
          relation: {
            RangeVar: {
              relname: 'enumtest',
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
                          str: 'red'
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
                          str: 'orange'
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
                          str: 'yellow'
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
                          str: 'green'
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
      stmt_len: 71
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateDomainStmt: {
          domainname: [
            {
              String: {
                str: 'rgb'
              }
            }
          ],
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'rainbow'
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
                              str: 'value'
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
                              str: 'red'
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            String: {
                              str: 'green'
                            }
                          }
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            String: {
                              str: 'blue'
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
      stmt_len: 71
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateEnumStmt: {
          typeName: [
            {
              String: {
                str: 'bogus'
              }
            }
          ]
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
            [
              {
                String: {
                  str: 'enumtest_child'
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
            [
              {
                String: {
                  str: 'enumtest_parent'
                }
              }
            ]
          ],
          removeType: 'OBJECT_TABLE',
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
                  str: 'enumtest'
                }
              }
            ]
          ],
          removeType: 'OBJECT_TABLE',
          behavior: 'DROP_RESTRICT'
        }
      },
      stmt_len: 20
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
                      str: 'rainbow'
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
        SelectStmt: {
          targetList: [
            {
              ResTarget: {
                val: {
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'count'
                        }
                      }
                    ],
                    agg_star: true
                  }
                }
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'pg_type',
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
                    str: '='
                  }
                }
              ],
              lexpr: {
                ColumnRef: {
                  fields: [
                    {
                      String: {
                        str: 'typname'
                      }
                    }
                  ]
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    String: {
                      str: 'rainbow'
                    }
                  }
                }
              }
            }
          },
          op: 'SETOP_NONE'
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
                relname: 'pg_enum',
                inh: true,
                relpersistence: 'p'
              }
            }
          ],
          whereClause: {
            BoolExpr: {
              boolop: 'NOT_EXPR',
              args: [
                {
                  SubLink: {
                    subLinkType: 'EXISTS_SUBLINK',
                    subselect: {
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
                        fromClause: [
                          {
                            RangeVar: {
                              relname: 'pg_type',
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
                                  str: '='
                                }
                              }
                            ],
                            lexpr: {
                              ColumnRef: {
                                fields: [
                                  {
                                    String: {
                                      str: 'pg_type'
                                    }
                                  },
                                  {
                                    String: {
                                      str: 'oid'
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
                                      str: 'enumtypid'
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
              ]
            }
          },
          op: 'SETOP_NONE'
        }
      },
      stmt_len: 95
    }
  }
];
