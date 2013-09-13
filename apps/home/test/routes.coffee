fabricate = require '../../../test/helpers/fabricate'
sinon = require 'sinon'
routes = require '../routes'
Backbone = require 'backbone'

describe '#index', ->

  beforeEach ->
    sinon.stub Backbone, 'sync'
    routes.index(
      {}
      { render: renderStub = sinon.stub() }
    )
    @templateName = renderStub.args[0][0]
    @templateOptions = renderStub.args[0][1]

  afterEach ->
    Backbone.sync.restore()

  it 'renders the hero units', ->
    @templateName.should.equal 'page'

describe '#sendLinkViaSMS', ->

  xit 'POST sends a link with a valid phone number'
  xit 'POST returns an error with an invalid phone number'
