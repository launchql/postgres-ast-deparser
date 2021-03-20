export const functions = [
  {
    CreateFunctionStmt: {
      funcname: [
        {
          String: {
            str: 'collections-private'
          }
        },
        {
          String: {
            str: 'deparse_a-const'
          }
        }
      ],
      parameters: [
        {
          FunctionParameter: {
            name: 'node-a',
            argType: {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'jsonb'
                    }
                  }
                ],
                typemod: -1
              }
            },
            mode: 'FUNC_PARAM_IN'
          }
        },
        {
          FunctionParameter: {
            name: 'context',
            argType: {
              TypeName: {
                names: [
                  {
                    String: {
                      str: 'text'
                    }
                  }
                ],
                typemod: -1
              }
            },
            mode: 'FUNC_PARAM_IN',
            defexpr: {
              A_Const: {
                val: {
                  Null: {}
                }
              }
            }
          }
        }
      ],
      returnType: {
        TypeName: {
          names: [
            {
              String: {
                str: 'text'
              }
            }
          ],
          typemod: -1
        }
      },
      options: [
        {
          DefElem: {
            defname: 'as',
            arg: [
              {
                String: {
                  str: 'some string'
                }
              }
            ],
            defaction: 'DEFELEM_UNSPEC'
          }
        },
        {
          DefElem: {
            defname: 'language',
            arg: {
              String: {
                str: 'plpgsql'
              }
            },
            defaction: 'DEFELEM_UNSPEC'
          }
        },
        {
          DefElem: {
            defname: 'security',
            arg: {
              Integer: {
                ival: 1
              }
            },
            defaction: 'DEFELEM_UNSPEC'
          }
        },
        {
          DefElem: {
            defname: 'volatility',
            arg: {
              String: {
                str: 'volatile'
              }
            },
            defaction: 'DEFELEM_UNSPEC'
          }
        }
      ]
    }
  }
];
