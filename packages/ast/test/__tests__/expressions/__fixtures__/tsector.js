export const tsvector_update_trigger = () => {
  return {
    FuncCall: {
      funcname: [
        {
          String: {
            str: 'tsvector_update_trigger'
          }
        }
      ],
      args: [
        {
          String: {
            str: 'tsvector_column_name'
          }
        },
        {
          A_Const: {
            val: {
              String: {
                str: 'pg_catalog.english'
              }
            }
          }
        },
        // as many args as you want below here...
        {
          String: {
            str: 'name'
          }
        },
        {
          String: {
            str: 'description'
          }
        }
      ]
    }
  };
};

export const setweight = (input, weight) => {
  return {
    FuncCall: {
      funcname: [
        {
          String: {
            str: 'setweight'
          }
        }
      ],
      args: [
        input,
        {
          A_Const: {
            val: {
              String: {
                str: weight
              }
            }
          }
        }
      ]
    }
  };
};

export const tsvector = (input) => {
  return {
    FuncCall: {
      funcname: [
        {
          String: {
            str: 'to_tsvector'
          }
        }
      ],
      args: input
    }
  };
};

export const aconst = (input) => {
  return {
    A_Const: {
      val: {
        String: {
          str: input
        }
      }
    }
  };
};

export const coalesce = (field) => {
  return {
    FuncCall: {
      funcname: [
        {
          String: {
            str: 'coalesce'
          }
        }
      ],
      args: [
        {
          String: {
            str: field
          }
        },
        {
          A_Const: {
            val: {
              String: {
                str: ''
              }
            }
          }
        }
      ]
    }
  };
};
