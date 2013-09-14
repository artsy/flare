# redirects iPhone to the app store
sd = require './shared_data.coffee'

module.exports = (options) =>
  IS_IPHONE = (navigator.userAgent.match(/iPhone/i) != null) || (navigator.userAgent.match(/iPod/i) != null)
  window.location = sd.IPHONE_APP_URL if IS_IPHONE
