module.exports = {
    entry: './static/index.js',

    output: {
        path: __dirname + '/build',
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
                test: /\.css$/,
                loader: 'style-loader!css-loader',
                exclude: /node_modules/
            },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-hot-loader!elm-webpack-loader?debug=true'
            }
        ],
        noParse: /\.elm$/
    },

    devServer: {
        inline: true,
        stats: 'errors-only'
    }
};
