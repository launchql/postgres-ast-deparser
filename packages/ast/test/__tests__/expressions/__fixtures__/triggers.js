export const triggers = [
  {
    CreateTrigStmt: {
      trigname: 'trigger_name',
      relation: {
        RangeVar: {
          schemaname: 'schema-name',
          relname: 'table_name',
          inh: true,
          relpersistence: 'p'
        }
      },
      funcname: [
        {
          String: {
            str: 'trigger_function_schema'
          }
        },
        {
          String: {
            str: 'trigger_function'
          }
        }
      ],
      row: true,
      timing: 2,
      events: 16,
      whenClause: {
        A_Expr: {
          kind: 'AEXPR_DISTINCT',
          name: [
            {
              String: {
                str: '='
              }
            }
          ],
          lexpr: {
            ColumnRef: {
              fields: [
                {
                  String: {
                    str: 'new'
                  }
                },
                {
                  String: {
                    str: 'field_name'
                  }
                }
              ]
            }
          },
          rexpr: {
            ColumnRef: {
              fields: [
                {
                  String: {
                    str: 'old'
                  }
                },
                {
                  String: {
                    str: 'field_name'
                  }
                }
              ]
            }
          }
        }
      }
    }
  }
];
