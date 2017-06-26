var express = require('express')
  , html = require('./assets/html')

var app = express()

app.use(require('../')({
  src: __dirname + '/assets',
  transforms: [require('caching-coffeeify')]
}))

app.get('/', function(req, res) {
  res.send(html())
})

app.listen(3000, function() {
  console.log('\nListening on http://localhost:3000 \n')
})
