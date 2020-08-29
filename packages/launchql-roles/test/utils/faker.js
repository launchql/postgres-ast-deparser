var jsf = require('json-schema-faker');

var schema = {
  type: 'object',
  properties: {
    display_name: {
      type: 'string',
      faker: 'name.findName'
    },
    username: {
      type: 'string',
      faker: 'name.findName'
    },
    password: {
      type: 'string',
      faker: 'name.findName'
    },
    email: {
      type: 'string',
      format: 'email',
      faker: 'internet.email'
    }
  },
  required: ['display_name', 'username', 'password', 'email']
};

function usernameify(text) {
  return text
    .toString()
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '-') // Replace spaces with -
    .replace(/&/g, '-and-') // Replace & with 'and'
    .replace(/[^\w\-]+/g, '') // Remove all non-word chars
    .replace(/\-\-+/g, '-') // Replace multiple - with single -
    .replace(/\-/g, '_'); // username
}

export const user = async () => {
  const obj = await jsf.resolve(schema);
  obj.email_is_verified = true;
  // obj.avatar_url = 'https://avatars1.githubusercontent.com/u/26897230?s=400&u=8064a2d500514cea0bc2c00a6da7e24c8c195841&v=4';
  obj.username = usernameify(obj.username);

  return obj;
};
