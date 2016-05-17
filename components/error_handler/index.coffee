fs = require 'fs'
jade = require 'jade'
sd = require('sharify').data

renderTemplate = jade.compile(
  fs.readFileSync(__dirname + '/template.jade')
  { filename: __dirname + '/template.jade' }
)

@internalError = (err, req, res, next) ->
  res.send 500, renderTemplate { code: 500, error: err, sd: sd }

@pageNotFound = (req, res, next) ->
  res.send 404, renderTemplate { code: 404, error: "Page not found", sd: sd }
