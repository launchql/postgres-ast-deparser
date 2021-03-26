export const references = [
  {
    RawStmt: {
      stmt: {
        CreateStmt: {
          relation: {
            RangeVar: {
              relname: 'orders',
              inh: true,
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_FOREIGN',
                      pktable: {
                        RangeVar: {
                          relname: 'products',
                          inh: true,
                          relpersistence: 'p'
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
                ]
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_FOREIGN',
                      pktable: {
                        RangeVar: {
                          relname: 'products',
                          inh: true,
                          relpersistence: 'p'
                        }
                      },
                      fk_matchtype: 's',
                      fk_upd_action: 'a',
                      fk_del_action: 'a',
                      initially_valid: true
                    }
                  }
                ]
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            },
            {
              Constraint: {
                contype: 'CONSTR_FOREIGN',
                pktable: {
                  RangeVar: {
                    relname: 'other_table',
                    inh: true,
                    relpersistence: 'p'
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
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true
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
              relpersistence: 'p'
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
              relpersistence: 'p'
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_FOREIGN',
                      pktable: {
                        RangeVar: {
                          relname: 'products',
                          inh: true,
                          relpersistence: 'p'
                        }
                      },
                      fk_matchtype: 's',
                      fk_upd_action: 'a',
                      fk_del_action: 'a',
                      initially_valid: true
                    }
                  }
                ]
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
                    typemod: -1
                  }
                },
                is_local: true,
                constraints: [
                  {
                    Constraint: {
                      contype: 'CONSTR_FOREIGN',
                      pktable: {
                        RangeVar: {
                          relname: 'orders',
                          inh: true,
                          relpersistence: 'p'
                        }
                      },
                      fk_matchtype: 's',
                      fk_upd_action: 'a',
                      fk_del_action: 'a',
                      initially_valid: true
                    }
                  }
                ]
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
                    typemod: -1
                  }
                },
                is_local: true
              }
            },
            {
              Constraint: {
                contype: 'CONSTR_PRIMARY',
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
          oncommit: 'ONCOMMIT_NOOP'
        }
      },
      stmt_len: 174
    }
  }
];
