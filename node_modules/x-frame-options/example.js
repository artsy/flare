var express = require('express')
var app = express()
var xFrameOptions = require('./')

app.use(xFrameOptions())

app.get('/', function (req, res) {
  console.log(res.get('X-Frame-Options')) // === 'Deny'
})

app.listen(3000)
