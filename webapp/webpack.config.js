const path = require('path');

module.exports = {
  entry: './src/index.js',

  output: {
    path: path.join(__dirname, "dist"),
    filename: 'index.js'
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    loaders: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file-loader?name=[name].[ext]'
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-hot-loader!elm-webpack-loader'
      }
    ],

    noParse: /\.elm$/
  },

  devServer: {
    inline: true,
    stats: 'errors-only'
  }
};
