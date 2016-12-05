var CopyWebpackPlugin = require('copy-webpack-plugin');
var CleanWebpackPlugin = require('clean-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

var merge = require('webpack-merge');
var webpack = require('webpack');
var path = require('path');

const env = process.env.NODE_ENV || 'development';

const base = {
  entry: {
    app: [
      "./web/static/sass/app.scss",
      "./web/static/js/app.js"
    ],
    vendor: ["jquery", "tether"]
  },

  output: {
    path: "./priv/static",
    filename: "assets/js/app.js"
  },

  resoluve: {
    moduleDirectories: ["node_modules", __dirname + "/web/static/js"]
  },

  module: {
    loaders: [
      {
        // Babel JS Loader
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        loader: "babel",
        query: {
          presets: ["es2015"]
        }
      },
      {
        // SASS Loader
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract(['css', 'sass'])
      },
      {
        // Font Loader
        test: /\.(otf|woff|woff2|eot|ttf|svg)(\?.*$|$)/,
        loader: 'file?name=assets/fonts/[name].[ext]&publicPath=../../'
      }
    ]
  },

  plugins: [
    new CopyWebpackPlugin([
      { from: './web/static/assets' },
      { from: './web/static/vendor', to: './assets/vendor' }
    ]),
    new webpack.optimize.CommonsChunkPlugin({
      name: 'vendor',
      filename: 'assets/js/vendor.js',
      chunks: ['vendor']
    }),
    new ExtractTextPlugin("assets/css/app.css"),
    new CleanWebpackPlugin(['priv/static'], {
      root: __dirname,
      verbose: false,
      dry: false
    })
  ]
}

var envConfig = {};

try {
  envConfig = require('./webpack.' + env + '.config');
}
catch(e) {
  console.log('Module "webpack.' + env + '.config.js" was not found.')
  console.log('  Continuing without environment specific configuration...')
}

module.exports = merge(base, envConfig);
