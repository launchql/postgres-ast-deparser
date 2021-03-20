module.exports = {
  A_Expr: {
    kind: 'AEXPR_IN',
    lexpr: {
      ColumnRef: {
        fields: [
          {
            String: {
              str: 'n'
            }
          },
          {
            String: {
              str: 'nspname'
            }
          }
        ]
      }
    },
    name: [
      {
        String: {
          str: '<>'
        }
      }
    ],
    rexpr: [
      {
        A_Const: {
          val: {
            String: {
              str: 'pg_catalog'
            }
          }
        }
      },
      {
        A_Const: {
          val: {
            String: {
              str: 'information_schema'
            }
          }
        }
      },
      {
        A_Const: {
          val: {
            String: {
              str: 'pg_toast'
            }
          }
        }
      }
    ]
  }
};
