twilio = require 'twilio'
{ TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_NUMBER, DEFAULT_CACHE_TIME, IPHONE_APP_URL } = require '../../config'

memjs = require('memjs')

index = (req, res, next) ->
  res.set? "Cache-Control": "public, s-maxage=#{DEFAULT_CACHE_TIME}"
  res.render 'page'

sendLinkViaSMS = (req, res, next) ->
  phone_number = req.body.phone_number.replace(/[^\d\+]/g, "")
  cache = memjs.Client.create()
  cache.get phone_number, (err, ts) ->
    if !err and ts?
      res.json 400, { success: false, message: 'You have already sent a download link to this number.' }
    else
      twilioClient = new twilio.RestClient TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN
      twilioClient.sendSms({
        to: phone_number
        from: TWILIO_NUMBER
        body: "Download the new Artsy iPhone app here: #{IPHONE_APP_URL}"
      }, (error, data) ->
        if error
          res.json error.status || 400, { success: false, code: error.code, message: error.message }
        else
          currTime = new Date().getTime()
          cache.set phone_number, currTime.toString(), null, 300
          res.json 201, { success: true, message: "Message sent.", sid: data.sid }
      )

module.exports = { index, sendLinkViaSMS }
