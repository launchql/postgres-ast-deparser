export const indexes = [
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'idx_CaseSimple',
          relation: {
            relname: 'Table_CaseSimple',
            inh: true,
            relpersistence: 'p',
            location: 33
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                name: 'CaseSimple',
                ordering: 'SORTBY_DEFAULT',
                nulls_ordering: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ]
        }
      },
      stmt_len: 66,
      stmt_location: 0
    }
  },
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'idx_simple',
          relation: {
            relname: 'table_simple',
            inh: true,
            relpersistence: 'p',
            location: 33
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                name: 'CaseSimple',
                ordering: 'SORTBY_DEFAULT',
                nulls_ordering: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ]
        }
      },
      stmt_len: 66,
      stmt_location: 0
    }
  },
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'idx_CaseExpression',
          relation: {
            relname: 'Table_CaseExperssion',
            inh: true,
            relpersistence: 'p',
            location: 106
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                expr: {
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'lower'
                        }
                      }
                    ],
                    args: [
                      {
                        ColumnRef: {
                          fields: [
                            {
                              String: {
                                str: 'CaseSimple'
                              }
                            }
                          ],
                          location: 136
                        }
                      }
                    ],
                    location: 130
                  }
                },
                ordering: 'SORTBY_DEFAULT',
                nulls_ordering: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ]
        }
      },
      stmt_len: 83,
      stmt_location: 67
    }
  },
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'idx_CaseInclude',
          relation: {
            relname: 'table_caseinclude',
            inh: true,
            relpersistence: 'p',
            location: 187
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                name: 'simple',
                ordering: 'SORTBY_DEFAULT',
                nulls_ordering: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          indexIncludingParams: [
            {
              IndexElem: {
                name: 'CaseInclude',
                ordering: 'SORTBY_DEFAULT',
                nulls_ordering: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ]
        }
      },
      stmt_len: 86,
      stmt_location: 151
    }
  },
  {
    RawStmt: {
      stmt: {
        IndexStmt: {
          idxname: 'idx_CaseIncludeExpr',
          relation: {
            relname: 'table_caseincludeexpr',
            inh: true,
            relpersistence: 'p',
            location: 277
          },
          accessMethod: 'btree',
          indexParams: [
            {
              IndexElem: {
                name: 'simple',
                ordering: 'SORTBY_DEFAULT',
                nulls_ordering: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ],
          indexIncludingParams: [
            {
              IndexElem: {
                expr: {
                  FuncCall: {
                    funcname: [
                      {
                        String: {
                          str: 'lower'
                        }
                      }
                    ],
                    args: [
                      {
                        ColumnRef: {
                          fields: [
                            {
                              String: {
                                str: 'CaseInclude'
                              }
                            }
                          ],
                          location: 323
                        }
                      }
                    ],
                    location: 317
                  }
                },
                ordering: 'SORTBY_DEFAULT',
                nulls_ordering: 'SORTBY_NULLS_DEFAULT'
              }
            }
          ]
        }
      },
      stmt_len: 100,
      stmt_location: 238
    }
  }
];
