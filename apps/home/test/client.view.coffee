Backbone = require 'backbone'
fabricate = require '../../../test/helpers/fabricate'
clientenv = require '../../../test/helpers/clientenv'
sinon = require 'sinon'

describe 'HomePageView', ->

  before (done) ->
    clientenv.prepare '../client/view', module,
      serverTemplate:
        filename: '../templates/page.jade'
        locals:
          sd: {}
      clientTemplates: []
      done: (@HomePageView) => done()

  beforeEach ->
    sinon.stub Backbone, 'sync'
    @view = new @HomePageView
    Backbone.sync.restore()
    sinon.stub Backbone, 'sync'

  afterEach ->
    Backbone.sync.restore()

  describe '#initialize', ->

    it 'renders', ->
      @view.initialize()
