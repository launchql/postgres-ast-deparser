import { getConnections } from '../../utils';

let db, teardown;
const objs = {
  tables: {}
};

// https://github.com/graphile/graphile-engine/blob/v4/packages/graphile-build-pg/src/utils.js
const parseTags = (str) => {
  return str.split(/\r?\n/).reduce(
    (prev, curr) => {
      if (prev.text !== '') {
        return { ...prev, text: `${prev.text}\n${curr}` };
      }
      const match = curr.match(/^@[a-zA-Z][a-zA-Z0-9_]*($|\s)/);
      if (!match) {
        return { ...prev, text: curr };
      }
      const key = match[0].substr(1).trim();
      const value = match[0] === curr ? true : curr.replace(match[0], '');
      return {
        ...prev,
        tags: {
          ...prev.tags,
          [key]: !Object.prototype.hasOwnProperty.call(prev.tags, key)
            ? value
            : Array.isArray(prev.tags[key])
            ? [...prev.tags[key], value]
            : [prev.tags[key], value]
        }
      };
    },
    {
      tags: {},
      text: ''
    }
  );
};

beforeAll(async () => {
  ({ db, teardown } = await getConnections());
  await db.begin();
  await db.savepoint();
});
afterAll(async () => {
  try {
    //try catch here allows us to see the sql parsing issues!
    await db.rollback();
    await db.commit();
    await teardown();
  } catch (e) {
    // noop
  }
});

it('smart_comments for any object', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_TABCONSTRAINT',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_table'),
            ast.string('my_constraint')
        ]),
        v_comment := ast_helpers.smart_comments(
            tags := $1::jsonb,
            description := $2
        )
    )
);`,
    [{ a: 1 }, 'my description']
  );
  expect(result).toMatchSnapshot();
});

it('smart_comments for any complext', async () => {
  const [{ expression: result }] = await db.any(
    `select deparser.expression(
    ast.comment_stmt(
        v_objtype := 'OBJECT_TABCONSTRAINT',
        v_object := to_jsonb(ARRAY[
            ast.string('my_schema'),
            ast.string('my_table'),
            ast.string('my_constraint')
        ]),
        v_comment := ast_helpers.smart_comments(
            tags := $1::jsonb,
            description := $2
        )
    )
);`,
    [
      {
        type: 'object',
        properties: {
          bookmarks: {
            type: 'array',
            minItems: 3,
            maxItems: 5,
            items: {
              type: 'object',
              properties: {
                id: {
                  type: 'number',
                  unique: true,
                  minimum: 1
                },
                url: {
                  type: 'string',
                  faker: 'internet.url'
                },
                title: {
                  type: 'string'
                },
                tags: {
                  type: 'string',
                  faker: 'custom.tags'
                }
              },
              required: ['id', 'url', 'title', 'tags']
            }
          }
        },
        required: ['bookmarks']
      },
      'my description'
    ]
  );
  expect(result).toMatchSnapshot();
});

it('smart_comments', async () => {
  const [{ smart_comments: result }] = await db.any(
    `select ast_helpers.smart_comments(
        tags := $1::jsonb,
        description := $2
    );`,
    [
      {
        type: 'object',
        properties: {
          bookmarks: {
            type: 'array',
            minItems: 3,
            maxItems: 5,
            items: {
              type: 'object',
              properties: {
                id: {
                  type: 'number',
                  unique: true,
                  minimum: 1
                },
                url: {
                  type: 'string',
                  faker: 'internet.url'
                },
                title: {
                  type: 'string'
                },
                tags: {
                  type: 'string',
                  faker: 'custom.tags'
                }
              },
              required: ['id', 'url', 'title', 'tags']
            }
          }
        },
        required: ['bookmarks']
      },
      'my description'
    ]
  );
  expect(result).toMatchSnapshot();
  // conclusion: looks like we can only do ONE-LEVEL JSON object SMART TAGS
  const evaluated = result.replace(new RegExp('\\\\n', 'g'), '\n');
  expect(parseTags(evaluated)).toMatchSnapshot();
});

it('smart_comments', async () => {
  const [{ smart_comments: result }] = await db.any(
    `select ast_helpers.smart_comments(
        tags := $1::jsonb,
        description := $2
    );`,
    [
      {
        type: 'object',
        props: ['id', "url'", 'title', 'tags']
      },
      'my description'
    ]
  );

  expect(result).toMatchSnapshot();
  // TODO determine why you have to "eval" the newlines...
  // I believe its because when we use these inside of postgres they get eval'd upon parsing
  const evaluated = result.replace(new RegExp('\\\\n', 'g'), '\n');
  expect(parseTags(evaluated)).toMatchSnapshot();
});
