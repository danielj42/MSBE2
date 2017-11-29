module.exports = {
  target: 'node',
  entry: './index.js',
  output: {
    filename: 'bundle.js',
    path: __dirname
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'eslint-loader'
      }
    ]
  },
  node: {
    fs: 'empty'
  },
  resolve: {
    mainFields: ['jsnext:main', 'browser', 'main'],
  },
  module:  {
    exprContextCritical: false,
  }
};
