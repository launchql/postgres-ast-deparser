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
                  // "\nDECLARE\n  txt text;\nBEGIN\n\n  IF (node->'A_Const') IS NULL THEN\n    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Const';\n  END IF;\n\n  node = node->'A_Const';\n\n  IF (node->'val') IS NULL THEN\n    RAISE EXCEPTION 'BAD_EXPRESSION %', 'A_Const';\n  END IF;\n\n  txt = collections_private.deparse_expression(node->'val', context);\n\n  IF (node->'val'->'String') IS NOT NULL THEN\n    txt = REPLACE(txt, '''', '''''' );\n    return format('''%s''', txt);\n  END IF;\n\n  RETURN txt;\n\nEND;\n"
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
