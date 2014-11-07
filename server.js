var express = require('express');
var port = process.env.PORT || 3000;
var app = express();

app.use('/', express.static(__dirname + '/output'))
app.use('/', express.static(__dirname + '/app'))
app.listen(port)
