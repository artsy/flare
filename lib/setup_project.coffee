# 
# Sets up intial project settings, middleware, mounted apps, and global configuration
# such as overriding Backbone.sync and populating ./shared_data
# 

express = require 'express'
path = require 'path'
Backbone = require 'backbone'
sd = require './shared_data'
asssetMiddleware = require './assets/middleware'
backboneServerSync = require './backbone_server_sync'
localsMiddleware = require './locals_middleware'
{ pageNotFound, internalError } = require '../components/error_handler'
{ PORT, SESSION_SECRET } = config = require '../config'

module.exports = (app) ->

  # Override backbone sync for server-side requests
  Backbone.sync = backboneServerSync

  # General settings
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.cookieParser(SESSION_SECRET)
  app.use express.cookieSession()
  app.use localsMiddleware
  sd.JS_EXT = '.js'
  sd.CSS_EXT = '.css'
  
  # Development settings
  if app.get('env') is 'development'
    app.use asssetMiddleware

  # Production settings
  if app.get('env') is 'production' or app.get('env') is 'staging'
    sd.JS_EXT = '.min.js.gz'
    sd.CSS_EXT = '.min.css.gz'
  
  # Inject configuration into the shared data
  sd[key] = config[key] ? val for key, val of sd
  
  # Mount apps
  app.use require '../apps/home'
  
  # More general middleware
  app.use express.static path.resolve __dirname, '../public'
  app.use pageNotFound
  app.use internalError
