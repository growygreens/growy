'use strict';

require.context('../assets', true, /\.png$/);
require.context('../assets/mdl', true, /\.css$/);
require('./main.scss');

var Elm = require('./Main');
Elm.Main.embed(document.getElementById('app'));
