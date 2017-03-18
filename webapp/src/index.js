'use strict';

require.context('../assets', true, /\.png$/);
require('./main.scss');

var Elm = require('./Main');
Elm.Main.embed(document.getElementById('app'));
