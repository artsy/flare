sinon = require 'sinon'
rewire = require 'rewire'
express = require 'express'
gravityXapp = rewire '../../lib/gravity_xapp'
sd = require '../../lib/shared_data'
servers = require '../helpers/servers'

describe 'gravityXapp', ->
  
  before (done) ->
    gravityXapp.__set__ 'GRAVITY_URL', 'http://localhost:5000/__gravity'
    servers.setup -> done()
  
  after ->
    servers.teardown()
  
  describe '#fetch', ->
  
    it 'returns the xapp token', (done) ->
      gravityXapp.fetch (err, token) ->
        token.should.equal 'xapp_foobar'
        done()
    
    it 'calls expireToken with good args', (done) ->
      expireStub = sinon.stub gravityXapp, 'expireToken'
      gravityXapp.fetch (err, token) ->
        expireStub.args[0][0].should.equal setTimeout
        expireStub.args[0][1].should.equal 'expires in utc string'
        expireStub.restore()
        done()
    
  describe '#expireToken', ->
    
    it 'expires the xapp token', ->
      gravityXapp.expireToken (spy = sinon.spy()), new Date(5000, 1, 1)
      spy.args[0][1].should.be.above 1
      sd.GRAVITY_XAPP_TOKEN = 'foo'
      spy.args[0][0]()
      (sd.GRAVITY_XAPP_TOKEN?).should.not.be.ok
        
  describe '#middleware', ->
    
    it 'injects the token into shared data', (done) ->
      sd.GRAVITY_XAPP_TOKEN = null
      gravityXapp.middleware {}, {}, ->
        sd.GRAVITY_XAPP_TOKEN.should.equal 'xapp_foobar'
        done()