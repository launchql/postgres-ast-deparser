module.exports = {
  A_Expr: {
    kind: 8,
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
          str: '~~'
        }
      }
    ],
    rexpr: {
      A_Const: {
        val: {
          String: {
            str: '%\'test\'%'
          }
        }
      }
    }
  }
};
  