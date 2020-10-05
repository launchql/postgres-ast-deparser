export const references = [
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'orders',
              inh: true,
              relpersistence: 'p',
              location: 13
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'order_id',
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
                    location: 35
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 5,
                      location: 43
                    }
                  }
                ],
                location: 26
              }
            },
            {
              ColumnDef: {
                colname: 'product_no',
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
                    location: 71
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 8,
                      location: 79,
                      pktable: {
                        RangeVar: {
                          relname: 'products',
                          inh: true,
                          relpersistence: 'p',
                          location: 90
                        }
                      },
                      pk_attrs: [
                        {
                          String: {
                            str: 'product_no'
                          }
                        }
                      ],
                      fk_matchtype: 's',
                      fk_upd_action: 'a',
                      fk_del_action: 'a',
                      initially_valid: true
                    }
                  }
                ],
                location: 60
              }
            },
            {
              ColumnDef: {
                colname: 'quantity',
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
                    location: 126
                  }
                },
                is_local: true,
                location: 117
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_len: 135
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'orders',
              inh: true,
              relpersistence: 'p',
              location: 150
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'order_id',
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
                    location: 172
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 5,
                      location: 180
                    }
                  }
                ],
                location: 163
              }
            },
            {
              ColumnDef: {
                colname: 'product_no',
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
                    location: 208
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 8,
                      location: 216,
                      pktable: {
                        RangeVar: {
                          relname: 'products',
                          inh: true,
                          relpersistence: 'p',
                          location: 227
                        }
                      },
                      fk_matchtype: 's',
                      fk_upd_action: 'a',
                      fk_del_action: 'a',
                      initially_valid: true
                    }
                  }
                ],
                location: 197
              }
            },
            {
              ColumnDef: {
                colname: 'quantity',
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
                    location: 250
                  }
                },
                is_local: true,
                location: 241
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 136,
      stmt_len: 123
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 't1',
              inh: true,
              relpersistence: 'p',
              location: 274
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
                    location: 283
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 5,
                      location: 291
                    }
                  }
                ],
                location: 281
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
                    location: 308
                  }
                },
                is_local: true,
                location: 306
              }
            },
            {
              ColumnDef: {
                colname: 'c',
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
                    location: 321
                  }
                },
                is_local: true,
                location: 319
              }
            },
            {
              Constraint: {
                contype: 8,
                location: 332,
                pktable: {
                  RangeVar: {
                    relname: 'other_table',
                    inh: true,
                    relpersistence: 'p',
                    location: 362
                  }
                },
                fk_attrs: [
                  {
                    String: {
                      str: 'b'
                    }
                  },
                  {
                    String: {
                      str: 'c'
                    }
                  }
                ],
                pk_attrs: [
                  {
                    String: {
                      str: 'c1'
                    }
                  },
                  {
                    String: {
                      str: 'c2'
                    }
                  }
                ],
                fk_matchtype: 's',
                fk_upd_action: 'a',
                fk_del_action: 'a',
                initially_valid: true
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 260,
      stmt_len: 124
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'products',
              inh: true,
              relpersistence: 'p',
              location: 399
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'product_no',
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
                    location: 425
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 5,
                      location: 433
                    }
                  }
                ],
                location: 414
              }
            },
            {
              ColumnDef: {
                colname: 'name',
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
                    location: 455
                  }
                },
                is_local: true,
                location: 450
              }
            },
            {
              ColumnDef: {
                colname: 'price',
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
                    typemod: -1,
                    location: 471
                  }
                },
                is_local: true,
                location: 465
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 385,
      stmt_len: 95
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'orders',
              inh: true,
              relpersistence: 'p',
              location: 495
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'order_id',
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
                    location: 517
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 5,
                      location: 525
                    }
                  }
                ],
                location: 508
              }
            },
            {
              ColumnDef: {
                colname: 'shipping_address',
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
                    location: 559
                  }
                },
                is_local: true,
                location: 542
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 481,
      stmt_len: 84
    }
  },
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'order_items',
              inh: true,
              relpersistence: 'p',
              location: 580
            }
          },
          tableElts: [
            {
              ColumnDef: {
                colname: 'product_no',
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
                    location: 609
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 8,
                      location: 617,
                      pktable: {
                        RangeVar: {
                          relname: 'products',
                          inh: true,
                          relpersistence: 'p',
                          location: 628
                        }
                      },
                      fk_matchtype: 's',
                      fk_upd_action: 'a',
                      fk_del_action: 'a',
                      initially_valid: true
                    }
                  }
                ],
                location: 598
              }
            },
            {
              ColumnDef: {
                colname: 'order_id',
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
                    location: 651
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 8,
                      location: 659,
                      pktable: {
                        RangeVar: {
                          relname: 'orders',
                          inh: true,
                          relpersistence: 'p',
                          location: 670
                        }
                      },
                      fk_matchtype: 's',
                      fk_upd_action: 'a',
                      fk_del_action: 'a',
                      initially_valid: true
                    }
                  }
                ],
                location: 642
              }
            },
            {
              ColumnDef: {
                colname: 'quantity',
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
                    location: 691
                  }
                },
                is_local: true,
                location: 682
              }
            },
            {
              Constraint: {
                contype: 5,
                location: 704,
                keys: [
                  {
                    String: {
                      str: 'product_no'
                    }
                  },
                  {
                    String: {
                      str: 'order_id'
                    }
                  }
                ]
              }
            }
          ],
          oncommit: 0
        }
      },
      stmt_location: 566,
      stmt_len: 174
    }
  }
];
