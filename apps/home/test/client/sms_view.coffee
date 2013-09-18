Backbone = require 'backbone'
fabricate = require '../../../../test/helpers/fabricate'
clientenv = require '../../../../test/helpers/clientenv'
sinon = require 'sinon'

describe 'SmsView', ->

  before (done) ->
    clientenv.prepare '../../client/sms_view', module,
      serverTemplate:
        filename: '../../templates/page.jade'
        locals:
          sd: {}
      clientTemplates: []
      done: (@SmsView) => done()

  beforeEach ->
    sinon.stub $, 'ajax'
    @view = new @SmsView el: $('#sms')

  afterEach ->
    $.ajax.restore()

  describe '#submit', ->

    it 'sends a twilio API call upon submit', ->
      @view.$('input.phone_number').val '555 102 2432'
      @view.$('button').trigger 'click'
      $.ajax.args[0][0].type.should.equal 'POST'
      $.ajax.args[0][0].url.should.include '/send_link'
      $.ajax.args[0][0].data.phone_number.should.equal '555 102 2432'
