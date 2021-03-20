export const intervals = [
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
                            str: '1 day 01:23:45.6789'
                          }
                        }
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
                              str: 'interval'
                            }
                          }
                        ],
                        typmods: [
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 32767
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
      stmt_len: 40
    }
  }
];
