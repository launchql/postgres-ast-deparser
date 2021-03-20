module.exports = {
  A_Expr: {
    kind: 'AEXPR_ILIKE',
    lexpr: {
      ColumnRef: {
        fields: [
          {
            String: {
              str: 'last_name'
            }
          }
        ]
      }
    },
    name: [
      {
        String: {
          str: '~~*'
        }
      }
    ],
    rexpr: {
      A_Const: {
        val: {
          String: {
            str: "%'test'%"
          }
        }
      }
    }
  }
};
