fabricate = require '../../../test/helpers/fabricate'
sinon = require 'sinon'
Backbone = require 'backbone'
rewire = require 'rewire'
routes = rewire '../routes'

describe '#index', ->

  beforeEach ->
    sinon.stub Backbone, 'sync'
    routes.index(
      {},
      { render: renderStub = sinon.stub() }
    )
    @templateName = renderStub.args[0][0]
    @templateOptions = renderStub.args[0][1]

  afterEach ->
    Backbone.sync.restore()

  it 'renders the hero units', ->
    @templateName.should.equal 'page'

describe '#sendLinkViaSMS', ->

  twilioConstructorArgs = null
  twilioSendSmsArgs = null
  resStub = null
  memJsSetArgs = null

  describe 'first time', ->
    beforeEach ->
      memjs = routes.__get__ 'memjs'
      memjs.Client =
        create: ->
          get: (key, callback) ->
            callback(null, null)
          set: (key, value, callback, expiration) ->
            memJsSetArgs = arguments

      twilio = routes.__get__ 'twilio'
      twilio.RestClient = class TwilioClientStub
        constructor: -> twilioConstructorArgs = arguments
        sendSms: -> twilioSendSmsArgs = arguments
      routes.sendLinkViaSMS { body: { phone_number: '+(555) 111 2222' } }, { json: resStub = sinon.stub() }

    it 'sends a link with a valid phone number', ->
      twilioSendSmsArgs[0].to.should.equal '+5551112222'
      twilioSendSmsArgs[0].body.should.containEql "Download the new Artsy iPhone app here: "
      twilioSendSmsArgs[1] null, 'SUCCESS!'
      resStub.args[0][1].message.should.containEql 'Message sent.'

    it 'throws an error if twilio doesnt like it', ->
      twilioSendSmsArgs[1] 'fail', { message: 'Error!' }
      resStub.args[0][1].message.should.containEql 'Error!'

    it 'sets sent in the cache', ->
      memJsSetArgs[0].should.equal '+5551112222'

    xit 'POST returns an error with an invalid phone number'

  describe 'second time', ->
    beforeEach ->
      memjs = routes.__get__ 'memjs'
      memjs.Client =
        create: ->
          get: (key, callback) ->
            callback(null, 'value set')
          set: (key, value, callback, expiration) ->
            memJsSetArgs = arguments

    it 'throws an error for subsequent requests', ->
      routes.sendLinkViaSMS { body: { phone_number: '+(555) 111 2222' } }, { json: resStub = sinon.stub() }
      resStub.args[0][1].message.should.containEql 'You have already sent a download link to this number.'

