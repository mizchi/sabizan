var webpack = require("webpack");
module.exports = {
  entry: {
    index: './example/index.coffee',
    sw: './example/sw.coffee'
  },
  output: {
    filename: 'example/[name].js'
  },

  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" },
    ]
  },

  resolve: {
    extensions: ["", ".coffee", ".js"]
  }
}
