#
# Sets up intial project settings, middleware, mounted apps, and global configuration
# such as overriding Backbone.sync and populating ./shared_data
#

{ NODE_ENV, PORT, ASSET_PATH, APPLICATION_NAME, DEFAULT_CACHE_TIME, WORKS_NUM, ARTISTS_NUM, GALLERIES_NUM, IPHONE_APP_URL  } = config = require "../config"

express = require 'express'
sharify = require "sharify"
path = require 'path'
Backbone = require 'backbone'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
favicon = require 'serve-favicon'
sd = require './shared_data'
logger = require 'morgan'
redirectIphone = require "./redirect_iphone"

{ pageNotFound, internalError } = require '../components/error_handler'

# Setup sharify constants & require dependencies that use sharify data
sharify.data =
  JS_EXT: (if ("production" is NODE_ENV or "staging" is NODE_ENV) then ".min.js.gz" else ".js")
  CSS_EXT: (if ("production" is NODE_ENV or "staging" is NODE_ENV) then ".min.css.gz" else ".css")
  ASSET_PATH: ASSET_PATH
  DEFAULT_CACHE_TIME: DEFAULT_CACHE_TIME
  WORKS_NUM: WORKS_NUM
  ARTISTS_NUM: ARTISTS_NUM
  GALLERIES_NUM: GALLERIES_NUM
  IPHONE_APP_URL: IPHONE_APP_URL

module.exports = (app) ->

  # Inject sharify data before anything
  app.use sharify

  # Development settings
  # Development / Test only middlewares that compile assets, mount antigravity, and
  # allow a back door to log in for tests.
  if "development" is NODE_ENV
    app.use require("stylus").middleware
      src: path.resolve(__dirname, "../")
      dest: path.resolve(__dirname, "../public")
    app.use require("browserify-dev-middleware")
      src: path.resolve(__dirname, "../")
      transforms: [require("jadeify"), require('caching-coffeeify')]

  # General settings
  app.use bodyParser.json()
  app.use bodyParser.urlencoded(extended: true)
  app.use cookieParser()

  app.use logger('dev')

  app.use redirectIphone

  # Mount apps
  app.use require '../apps/home'

  # More general middleware
  app.use favicon(path.resolve __dirname, '../public/assets/favicon.ico')
  app.use express.static(path.resolve __dirname, "../public")
  app.use pageNotFound
  app.use internalError
