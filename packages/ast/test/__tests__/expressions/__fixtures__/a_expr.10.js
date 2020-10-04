module.exports = {
  A_Expr: {
    kind: 10,
    lexpr: {
      A_Const: {
        val: {
          String: {
            str: 'abc'
          }
        }
      }
    },
    name: [
      {
        String: {
          str: '~'
        }
      }
    ],
    rexpr: {
      FuncCall: {
        args: [
          {
            FuncCall: {
              args: [
                {
                  A_Const: {
                    val: {
                      String: {
                        str: 'test'
                      }
                    }
                  }
                }
              ],
              funcname: [
                {
                  String: {
                    str: 'test'
                  }
                }
              ],
            }
          },
          {
            A_Const: {
              val: {
                String: {
                  str: 't'
                }
              }
            }
          }
        ],
        funcname: [
          {
            String: {
              str: 'pg_catalog'
            }
          },
          {
            String: {
              str: 'similar_escape'
            }
          }
        ],
      }
    }
  }
};
  