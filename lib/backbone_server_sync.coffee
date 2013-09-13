#
# Overrides Backbone.sync to work on the server by using superagent
#
# TODO: Extract into it's own Open Source node module.
#

request = require 'superagent'
_ = require 'underscore'
sd = require '../lib/shared_data.coffee'
Backbone = require 'backbone'
Backbone._sync = Backbone.sync
METHOD_MAP =
  'create': 'post'
  'update': 'put'
  'delete': 'del'
  'read':   'get'

module.exports = (method, model, options) ->
  httpMethod = METHOD_MAP[method]
  url = _.result model, 'url'
  data = options.data or (if method in ['create', 'update'] then model.toJSON() else {})
  req = request[httpMethod](url)
  req = if method in ['create', 'update']
          req.send(data).set('content-length', JSON.stringify(data).length)
        else
          req.query(data)
  req.end (res) ->
    if res.ok then options.success?(res.body) else options.error?(res.error)
  model.trigger('request', model)
