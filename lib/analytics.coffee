#
# Simple wrapper around mixpanel to simplify common analytics actions.
# This should also provide a central place to put analytics logic when/if other
# services like Google Analytics are integrated.
#

sd = require './shared_data.coffee'

module.exports = (options) =>
  { @mixpanel, @ga, @location } = options
  @location ?= window?.location
  @ga? 'create', sd.GOOGLE_ANALYTICS_ID, 'artsy.net'
  @mixpanel?.init sd.MIXPANEL_ID

module.exports.trackPageview = =>
  @ga? 'send', 'pageview'
  @mixpanel?.track? 'Viewed page', { path: @location.pathname }

module.exports.track = (action) =>
  @mixpanel?.track? action, { path: @location.pathname }
