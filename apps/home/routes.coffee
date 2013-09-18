twilio = require 'twilio'
{ TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_NUMBER, DEFAULT_CACHE_TIME, IPHONE_APP_URL } = require '../../config'

module.exports.index = (req, res, next) ->
  res.set? "Cache-Control": "public, s-maxage=#{DEFAULT_CACHE_TIME}"
  res.render 'page'

@sendLinkViaSMS = (req, res, next) ->
  twilioClient = new twilio.RestClient TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN
  twilioClient.sendSms({
    to: req.body.phone_number
    from: TWILIO_NUMBER
    body: "Download the new Artsy iPhone app here: #{IPHONE_APP_URL}"
  }, (error, data) ->
    if error
      res.json data.status || 400, { success: false, code: data.code, message: data.message }
    else
      res.json 201, { success: true, message: "Message sent.", sid: data.sid }
  )
