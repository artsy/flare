#
# Middleware used to compile assets on request for development.
#

_ = require 'underscore'
path = require 'path'
stylus = require 'stylus'
coffeeify = require 'caching-coffeeify'
jadeify = require 'jadeify2'

stylusMiddleware = stylus.middleware
  src: (reqPath) ->
    path.resolve(__dirname, '../../components/asset_package') + '/' +
      _.last(reqPath.split '/').replace('.css', '.styl')
  dest: (reqPath) ->
    path.resolve(__dirname, '../../public/assets') + '/' + _.last(reqPath.split '/')

browserifyMiddleware = (req, res, next) ->
  if req.url is '/assets/all.js'
    b = require('browserify')()
    b.add path.resolve __dirname, '../../components/asset_package/all.coffee'
    b.transform coffeeify
    b.transform jadeify
    b.bundle().pipe(res)
  else
    next()

module.exports = (req, res, next) ->
  switch path.extname req.url
    when '.css' then stylusMiddleware req, res, next
    when '.js' then browserifyMiddleware req, res, next
    else next()
