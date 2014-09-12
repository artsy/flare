#
# Redirect iphone to iphone app
#
sd = require('sharify')

module.exports = (req, res, next) ->
  ua = req.headers['user-agent']
  res.locals.sd.BROWSER = ua unless res.locals.sd.BROWSER
  if sd.data.IPHONE_APP_URL and ((ua.match(/iPhone/i) != null) || (ua.match(/iPod/i) != null))
    res.redirect sd.data.IPHONE_APP_URL
  else
    next()
