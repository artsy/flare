#
# Using ["The Twelve-Factor App"](http://12factor.net/) as a reference
# all environment configuration will live in environment variables.
# This file simply lays out all of those environment variables with
# sensible defaults for development.
#

module.exports =

  NODE_ENV:                'development'
  ASSET_PATH:              '/assets/'
  PORT:                    3003
  S3_KEY:                  null
  S3_SECRET:               null
  APPLICATION_NAME:        'flare-development'
  SESSION_SECRET:          'session-secret'
  SEGMENT_API_KEY:         null
  STRONGLOOP_KEY:          null
  IPHONE_APP_URL:          'https://itunes.apple.com/us/app/artsy-art-world-in-your-pocket/id703796080?ls=1&mt=8'
  TWILIO_NUMBER:           null
  TWILIO_ACCOUNT_SID:      null
  TWILIO_AUTH_TOKEN:       null
  SOURCE_URL:              'https://github.com/artsy/flare'
  CANONICAL_URL:           'http://iphone.artsy.net'
  HOME_URL:                'http://artsy.net'
  HOME_HOSTNAME:           'artsy.net'
  DEFAULT_CACHE_TIME:      '1800' # 30 minutes in seconds
  WORKS_NUM:               '230,000'
  ARTISTS_NUM:             '40,000'
  GALLERIES_NUM:           '2,000'
  FAIRS_NUM:               '80'
  MUSEUMS_NUM:             '800'
  PARTNER_HIGHLIGHT_COPY:  'Gagosian Gallery, Pace Gallery, White Cube, the Guggenheim, SFMOMA, The British Museum, TEFAF, and The Armory Show.'

# Override any values with env variables if they exist
module.exports[key] = (process.env[key] or val) for key, val of module.exports
