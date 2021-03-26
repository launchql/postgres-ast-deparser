module.exports = {
  A_Expr: {
    kind: 'AEXPR_BETWEEN',
    lexpr: {
      ColumnRef: {
        fields: [
          {
            String: {
              str: 'd'
            }
          }
        ]
      }
    },
    name: [
      {
        String: {
          str: 'BETWEEN'
        }
      }
    ],
    rexpr: [
      {
        TypeCast: {
          arg: {
            A_Const: {
              val: {
                String: {
                  str: '2010-01-01'
                }
              }
            }
          },
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'date'
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
                String: {
                  str: '2010-12-31'
                }
              }
            }
          },
          typeName: {
            TypeName: {
              names: [
                {
                  String: {
                    str: 'date'
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
};
