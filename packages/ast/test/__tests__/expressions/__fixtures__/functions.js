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
                typemod: -1,
                location: 61
              }
            },
            mode: 105
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
                typemod: -1,
                location: 78
              }
            },
            mode: 105,
            defexpr: {
              A_Const: {
                val: {
                  Null: {}
                },
                location: 91
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
          typemod: -1,
          location: 106
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
            defaction: 0,
            location: 111
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
            defaction: 0,
            location: 587
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
            defaction: 0,
            location: 606
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
            defaction: 0,
            location: 623
          }
        }
      ]
    }
  }
];
