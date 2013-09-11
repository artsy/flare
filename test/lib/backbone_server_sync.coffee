sinon = require 'sinon'
express = require 'express'
Backbone = require 'backbone'
backboneServerSync = require '../../lib/backbone_server_sync'
sd = require '../../lib/shared_data.coffee'

describe 'Backbone server sync', ->

  before (done) ->
    app = express()
    app.use express.bodyParser()
    app.all '/foo/bar', (@req, res) =>
      res.send { foo: 'bar' }
    app.get '/foo/err', (@req, res) =>
      res.send 404, { message: 'Not Found' }
    @server = app.listen 5001, done

  after ->
    @server.close()
  
  beforeEach ->
    sd.GRAVITY_XAPP_TOKEN = 'footoken'
    @model = new Backbone.Model
    @model.sync = backboneServerSync
    @model.url = 'http://localhost:5001/foo/bar'
    
  afterEach ->
    Backbone.sync = Backbone._sync
  
  context 'GET requests', ->
    
    it 'adds the xapp token to the headers', (done) ->
      @model.fetch success: =>
        @req.get('X-XAPP-TOKEN').should.include 'footoken'
        done()
    
    it 'updates the model', (done) ->
      @model.fetch success: =>
        @model.get('foo').should.equal 'bar'
        done()
  
    it 'calls the error callback', (done) ->
      @model.url = 'http://localhost:5001/foo/err'
      @model.fetch error: -> done()
    
    it 'accepts data params and adds them to query params', (done) ->
      @model.fetch data: { foo: 'bar' }, success: =>
        @req.query.foo.should.equal 'bar'
        done()
      
  context 'POST requests', ->
  
    it 'adds the content-length header', (done) ->
      @model.save { foo: 'bar' }, success: =>
        @req.headers['content-length'].should.equal '13'
        done()

    it 'adds the body data', (done) ->
      @model.save { foo: 'bar' }, success: =>
        @req.body.foo.should.equal 'bar'
        done()