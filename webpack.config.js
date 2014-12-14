var webpack = require("webpack");
var path = require('path');

module.exports = {
  entry: './bundler.js',

  output: {
    filename: 'public/bundle.js'
  },

  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" },
      { test: /\.css$/   , loader: "style!css?root=." }
    ]
  },

  resolve: {
    root: [path.join(__dirname, "bower_components")],
    extensions: ["", ".coffee", ".js"]
  },

  plugins: [
    new webpack.ResolverPlugin(
      new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
    )
  ]
}

