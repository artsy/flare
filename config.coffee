#
# Using ["The Twelve-Factor App"](http://12factor.net/) as a reference
# all environment configuration will live in environment variables.
# This file simply lays out all of those environment variables with
# sensible defaults for development.
#

module.exports =

  NODE_ENV:                'development'
  CDN_URL:                 '/assets/'
  PORT:                    3003
#  S3_KEY:                  ''
#  S3_SECRET:               ''
  APPLICATION_NAME:        'flare-development'
  SESSION_SECRET:          'session-secret'
#  MIXPANEL_ID:             ''
#  STRONGLOOP_KEY:          ''
#  GOOGLE_ANALYTICS_ID:     ''
  IPHONE_APP_URL:          'https://itunes.apple.com/us/app/artsy-art-world-in-your-pocket/id703796080?ls=1&mt=8'
#  TWILIO_NUMBER:           ''
#  TWILIO_ACCOUNT_SID:      ''
#  TWILIO_AUTH_TOKEN:       ''
  ARTSY_URL:               'http://artsy.net'
  CANONICAL_URL:           'http://iphone.artsy.net'
  DEFAULT_CACHE_TIME:      '1800' # 30 minutes in seconds

# Override any values with env variables if they exist
module.exports[key] = (process.env[key] or val) for key, val of module.exports
