'use strict';

require.context('../assets', true, /\.png$/);
require.context('../assets/mdl', true, /\.css$/);

require('../assets/font-awesome-4.7.0/css/font-awesome.min.css');
require.context('../assets/font-awesome-4.7.0/fonts', true, /\.(eot|svg|ttf|woff|woff2)$/);

require('./main.scss');

var Elm = require('./Main');
Elm.Main.embed(document.getElementById('app'));
