module.exports = {
  A_Expr: {
    kind: 12,
    lexpr: {
      ColumnRef: {
        fields: [
          {
            String: {
              str: 'd'
            }
          }
        ],
      }
    },
    name: [
      {
        String: {
          str: 'NOT BETWEEN'
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
