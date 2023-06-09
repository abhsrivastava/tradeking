const path = require('path')
const outputDir = path.join(__dirname, "build")
const HtmlWebpackPlugin = require('html-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const Dotenv = require('dotenv-webpack');

module.exports = {
  mode: "development",
  watch: true,
  entry: "./src/Index.bs.js",
  output: {
    path: outputDir,
    publicPath: '/',
    filename: 'index.js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/Index.html',
      inject: false
    }),
    new CopyWebpackPlugin({
      patterns: [
        {from: './src/images', to: 'images'}
      ]
    }),
    new Dotenv()
  ],
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  devServer: {
    historyApiFallback: {
      rewrites: [
        {
          from: /^\/detail\/index.js$/,
          to: function(context) {
            return 'index.js';
          }
        },
        {
          from: /^\/detail\/.*$/,
          to: function(context) {
            return 'index.html';
          }
        }        
      ]      
    },
    hot: true,
    static: {
      directory: outputDir,
    },
    compress: true,
    port: 8001
  }
}