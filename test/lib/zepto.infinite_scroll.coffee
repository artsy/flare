sinon = require 'sinon'
clientenv = require '../helpers/clientenv'

describe 'infiniteScroll', ->

  before (done) ->
    clientenv.setup =>
      @onScroll = require '../../lib/zepto/infinite_scroll'
      done()
  
  beforeEach ->
    @scrollTopStub = sinon.stub $.fn, 'scrollTop'
    @heightStub = sinon.stub $.fn, 'height'
    @scrollTopStub.returns 10
    @heightStub.returns 10
  
  afterEach ->
    @scrollTopStub.restore()
    @heightStub.restore()
    
  it 'triggeres an infinite scroll event if the user has reached the bottom', ->
    $(window).on 'infiniteScroll', spy = sinon.spy()
    @onScroll()
    spy.called.should.be.ok