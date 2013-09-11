# 
# Middleware that injects common template [locals](http://expressjs.com/api.html#res.locals)
# such as the session id, user agent, or ./shared_data.
# 

sd = require './shared_data'
_ = require 'underscore'
uuid = require 'node-uuid'

module.exports = (req, res, next) ->
  requestData =
    SESSION_ID: req.session?.id ?= uuid.v1()
    USER_AGENT: req.headers?['user-agent']
  res.locals =
    sd: sd
    rd: requestData
    bootstrapData: _.extend sd, requestData
    htmlClass: ""
  next()
