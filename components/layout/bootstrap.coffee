# 
# Common bootstrap code that needs to be run on the client-side.
# Includes adding the XAPP token to ajax requests and loading bootstrapped data into
# the shared_data module.
# 
# Don't go too wild here, we want to keep this minimal and light-weight because it could be 
# included across most apps and any uncessary bloat should be avoided.
# 

require '../../lib/zepto/index.coffee'
Backbone = require 'backbone'
Backbone.$ = $
sd = require '../../lib/shared_data.coffee'
analytics = require '../../lib/analytics.coffee'

module.exports = ->
  
  # Inject shared data
  sd[key] = BOOTSTRAP[key] for key, val of sd
  
  # Add the Gravity access token to all ajax requests
  $.ajaxSettings.headers = {
    "X-XAPP-TOKEN": sd.GRAVITY_XAPP_TOKEN
  }
  
  # Initialize analytics & track page view if we included mixpanel
  # (not included in test environment).
  unless typeof mixpanel is 'undefined'
    analytics(mixpanel: mixpanel, ga: ga)
    analytics.trackPageview()
    
# Show search button on focusing the search bar
$('#main-header-search-box').focus ->
  $('#main-header-search-button').show()
$('#main-header-search-form').blur ->
  $('#main-header-search-button').hide()