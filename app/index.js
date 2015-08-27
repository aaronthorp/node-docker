var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Container '+process.env.HOSTNAME+', running on port ' + process.env.PORT + '\n');
}).listen(process.env.PORT);
console.log('Container '+process.env.HOSTNAME+', running on port ' + process.env.PORT);
