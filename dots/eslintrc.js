// TODO: Set up sane defaults for personal projects, probably in node land, as
// anything else will be running in some other env and likely have its own
// eslint config

module.exports = {
  rules: {
    'no-console': 'warn',
    semi: 'error',
  },
  parserOptions: {
    ecmaVersion: 6,
  },
  env: {
    node: true,
  },
};
