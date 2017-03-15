'use strict';

require('./index.html');
require.context('../assets', true, /\.png$/);
var Elm = require('./Main');

Elm.Main.embed(document.getElementById('app'));
