module.exports = {
  entry: './index.js',
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/,
          /node_modules/],
        loader: 'elm-webpack-loader'
      }
    ]
  },
  output: {
    filename: 'bundle.js',
    path: __dirname
  }
};
