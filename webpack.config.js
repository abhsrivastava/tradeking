const path = require('path')
const outputDir = path.join(__dirname, "build")
const HtmlWebpackPlugin = require('html-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const dotenv = require('dotenv').config({
  path: path.join(__dirname, ".env")
})

module.exports = {
  mode: "development",
  watch: "true",
  entry: "./src/Index.bs.js",
  output: {
    path: outputDir,
    filenam: 'index.js'
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
    new webpack.DefinePlugin({
      "process.env": dotenv.parsed
    })
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
    historyApiFallback: true,
    static: {
      directory: outputDir,
    },
    compress: true,
    port: 8000
  }
}