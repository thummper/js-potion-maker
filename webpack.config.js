const path = require("path");
const HTMLPack = require("html-webpack-plugin");
module.exports = {
    module:{
        rules: [{
            test: /\.scss$/,
            use: [
                "style-loader", //Creates style nodes from JS Strings
                "css-loader", // translates css into commonjs
                "sass-loader" // compiles sass to css
            ]
        }
    ]},
    plugins: [
        new HTMLPack({
            hash: true,
            template: './src/html/index.html'
        }),
    ],
    entry: "./src/js/index.js",
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: "main.js"
    },
    devServer: {
        contentBase: path.join(__dirname, 'dist'),
        inline: true,
        port: 3000
      },
};