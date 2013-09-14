#
# An empty hash of "global" project-level data that needs to be shared across apps
# and between the server and client, such as the gravity url or an xapp token.
# This provides a central place to store this project-level data without having to resort
# to exposing it globally. Since this data will be included on the client, be sure not
# to add any passwords or keys. That should only live in config.coffee.
#
# The server or client injects data into this hash via config or bootstrapped
# data. Specifying the keys of the hash will help automatically populate this hash.
# e.g. adding "GRAVITY_URL" will tell the server to look for that in config.coffee and
# expose it to the client.
#

module.exports =
  CDN_URL: null
  JS_EXT: null
  CSS_EXT: null
  NODE_ENV: null
  MIXPANEL_ID: null
  SECURE_URL: null
  GOOGLE_ANALYTICS_ID: null
  IPHONE_APP_URL: null
  ARTSY_URL: null
  CANONICAL_URL: null
