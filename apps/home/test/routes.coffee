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

  twilioConstructorArgs = null; twilioSendSmsArgs = null; resStub = null;

  beforeEach ->
    twilio = routes.__get__ 'twilio'
    twilio.RestClient = class TwilioClientStub
      constructor: -> twilioConstructorArgs = arguments
      sendSms: -> twilioSendSmsArgs = arguments
    routes.sendLinkViaSMS { body: { phone_number: '555 111 2222' } }, { json: resStub = sinon.stub() }

  it 'sends a link with a valid phone number', ->
    twilioConstructorArgs[0].length.should.be.above 5
    twilioConstructorArgs[1].length.should.be.above 5
    twilioSendSmsArgs[0].to.should.equal '555 111 2222'
    twilioSendSmsArgs[0].from.should.equal '(917) 746-8750'
    twilioSendSmsArgs[0].body.should.include "Download the new Artsy iPhone app here: "
    twilioSendSmsArgs[1] null, 'SUCCESS!'
    resStub.args[0][1].message.should.include 'Message sent.'

  it 'throws an error if twilio doesnt like it', ->
    twilioSendSmsArgs[1] 'fail', { message: 'You suck!' }
    resStub.args[0][1].message.should.include 'You suck!'

  xit 'POST returns an error with an invalid phone number'
