setup = require '../../lib/setup_project'
Backbone = require 'backbone'
express = require 'express'
backboneServerSync = require '../../lib/backbone_server_sync'
sd = require '../../lib/shared_data'
config = require '../../config'
sinon = require 'sinon'

describe 'Project setup', ->
  
  before ->
    @app = express()
    setup @app
  
  it 'overrides backbone sync with server sync', ->
    Backbone.sync.should.equal backboneServerSync
    
  it 'sets the JS_EXT and CSS_EXT for normal .js an .css for dev', ->
    sd.JS_EXT.should.equal '.js'
    sd.CSS_EXT.should.equal '.css'
  
  context 'for production', ->
    
    beforeEach ->
      @app = express()
      @app.set 'env', 'production'
      setup @app
    
    it 'sets the JS_EXT and CSS_EXT for production', ->
      sd.JS_EXT.should.equal '.min.js.gz'
      sd.CSS_EXT.should.equal '.min.css.gz'
  
  context 'for test', ->
    
    beforeEach ->
      @app = express()
      @app.set 'env', 'test'
      setup @app
    
    it 'mounts gravity for test', ->
      routes = (layer.route for layer in @app.stack)
      ('/__gravity' in routes).should.be.ok
      
  it 'inject configuration into shared data', ->
    sd.GRAVITY_URL = ''
    setup @app
    sd.GRAVITY_URL.should.equal config.GRAVITY_URL