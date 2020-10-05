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
                        },
                        location: 19
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
                              },
                              location: -1
                            }
                          },
                          {
                            A_Const: {
                              val: {
                                Integer: {
                                  ival: 0
                                }
                              },
                              location: 16
                            }
                          }
                        ],
                        typemod: -1,
                        location: 7
                      }
                    },
                    location: -1
                  }
                },
                location: 7
              }
            }
          ],
          op: 0
        }
      },
      stmt_len: 40
    }
  }
];
