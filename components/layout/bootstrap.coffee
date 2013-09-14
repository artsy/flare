#
# Common bootstrap code that needs to be run on the client-side.
#
# Don't go too wild here, we want to keep this minimal and light-weight because it could be
# included across most apps and any uncessary bloat should be avoided.
#

require '../../lib/jquery.js'
Backbone = require 'backbone'
Backbone.$ = $
popLockit = require '../../lib/jquery.poplockit.coffee'
sd = require '../../lib/shared_data.coffee'
analytics = require '../../lib/analytics.coffee'

module.exports = ->

  # Inject shared data
  sd[key] = BOOTSTRAP[key] for key, val of sd

  # Initialize analytics & track page view if we included mixpanel
  # (not included in test environment).
  unless typeof mixpanel is 'undefined'
    analytics(mixpanel: mixpanel, ga: ga)
    analytics.trackPageview()
