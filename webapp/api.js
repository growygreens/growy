var jsonServer = require('json-server');

var server = jsonServer.create();
server.use(jsonServer.defaults());

//var router = jsonServer.router('mock-db.json');
var router = jsonServer.router('runabergs.json');
server.use(router);

console.log('Mock DB Server API -- Listening at 4000');
server.listen(4000);
