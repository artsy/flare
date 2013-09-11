# 
# XAPP token library for Gravity. Includes function to fetch xapp token
# and middleware to ensure the XAPP token is injected in lib/shared_data.
# 

request = require 'superagent'
{ GRAVITY_URL, CLIENT_ID, CLIENT_SECRET } = require '../config'
sd = require './shared_data'
moment = require 'moment'

@fetch = (callback) =>
  request.get("#{GRAVITY_URL}/api/v1/xapp_token").query(
    client_id: CLIENT_ID
    client_secret: CLIENT_SECRET
  ).end (err, res) =>
    return callback err if err
    @expireToken setTimeout, res.body.expires_in
    callback null, res.body.xapp_token

@middleware = (req, res, next) =>
  unless sd.GRAVITY_XAPP_TOKEN?
    @fetch (err, token) ->
      sd.GRAVITY_XAPP_TOKEN = token
      next()
  else
    next()
    
@expireToken = (timeout, expiresIn) ->
  timeout ->
    sd.GRAVITY_XAPP_TOKEN = null
  , moment(expiresIn).unix() - moment().unix()