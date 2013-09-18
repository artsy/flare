twilio = require 'twilio'
{ TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_NUMBER, DEFAULT_CACHE_TIME } = require '../../config'

module.exports.index = (req, res, next) ->
  res.setHeader "Cache-Control", "public, s-maxage=#{DEFAULT_CACHE_TIME}"
  res.render 'page'

@sendLinkViaSMS = (req, res, next) ->
  twilioClient = new twilio.RestClient TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN
  twilioClient.sendSms({
    to: req.body.phone_number
    from: TWILIO_NUMBER
    body: 'Get the new Artsy iPhone app at http://artsy.net/supersecretbeta ...'
  }, (error, data) ->
    if error
      res.json data.status || 400, { success: false, code: data.code, message: data.message }
    else
      res.json 201, { success: true, message: "Message sent.", sid: data.sid }
  )
