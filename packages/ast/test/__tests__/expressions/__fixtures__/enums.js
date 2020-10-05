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
      stmt_location: 83,
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
      stmt_location: 141,
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
      stmt_location: 180,
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
      stmt_location: 235,
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
                              },
                              location: 308
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
                              typemod: -1,
                              location: 314
                            }
                          },
                          location: 312
                        }
                      }
                    ],
                    location: 298
                  }
                },
                location: 298
              }
            }
          ],
          op: 0
        }
      },
      stmt_location: 290,
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
      stmt_location: 323,
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
              relpersistence: 'p',
              location: 378
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
                      },
                      location: 395
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
                      },
                      location: 404
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
                      },
                      location: 416
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
                      },
                      location: 428
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
      stmt_location: 365,
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
              typemod: -1,
              location: 459
            }
          },
          constraints: [
            {
              Constraint: {
                contype: 4,
                location: 467,
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
                              str: 'value'
                            }
                          }
                        ],
                        location: 474
                      }
                    },
                    rexpr: [
                      {
                        A_Const: {
                          val: {
                            String: {
                              str: 'red'
                            }
                          },
                          location: 484
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            String: {
                              str: 'green'
                            }
                          },
                          location: 491
                        }
                      },
                      {
                        A_Const: {
                          val: {
                            String: {
                              str: 'blue'
                            }
                          },
                          location: 500
                        }
                      }
                    ],
                    location: 480
                  }
                },
                initially_valid: true
              }
            }
          ]
        }
      },
      stmt_location: 437,
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
      stmt_location: 509,
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
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 538,
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
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 565,
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
          removeType: 37,
          behavior: 0
        }
      },
      stmt_location: 593,
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
                typemod: -1,
                location: 625
              }
            }
          ],
          removeType: 45,
          behavior: 0
        }
      },
      stmt_location: 614,
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
                    agg_star: true,
                    location: 641
                  }
                },
                location: 641
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'pg_type',
                inh: true,
                relpersistence: 'p',
                location: 655
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
                        str: 'typname'
                      }
                    }
                  ],
                  location: 669
                }
              },
              rexpr: {
                A_Const: {
                  val: {
                    String: {
                      str: 'rainbow'
                    }
                  },
                  location: 679
                }
              },
              location: 677
            }
          },
          op: 0
        }
      },
      stmt_location: 633,
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
                    location: 697
                  }
                },
                location: 697
              }
            }
          ],
          fromClause: [
            {
              RangeVar: {
                relname: 'pg_enum',
                inh: true,
                relpersistence: 'p',
                location: 704
              }
            }
          ],
          whereClause: {
            BoolExpr: {
              boolop: 2,
              args: [
                {
                  SubLink: {
                    subLinkType: 0,
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
                                  },
                                  location: 739
                                }
                              },
                              location: 739
                            }
                          }
                        ],
                        fromClause: [
                          {
                            RangeVar: {
                              relname: 'pg_type',
                              inh: true,
                              relpersistence: 'p',
                              location: 746
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
                                      str: 'pg_type'
                                    }
                                  },
                                  {
                                    String: {
                                      str: 'oid'
                                    }
                                  }
                                ],
                                location: 760
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
                                ],
                                location: 774
                              }
                            },
                            location: 772
                          }
                        },
                        op: 0
                      }
                    },
                    location: 722
                  }
                }
              ],
              location: 718
            }
          },
          op: 0
        }
      },
      stmt_location: 689,
      stmt_len: 95
    }
  }
];
