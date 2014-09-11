Backbone = require 'backbone'
benv = require 'benv'
sinon = require 'sinon'
path = require 'path'
fs = require 'fs'
jade = require 'jade'

render = (templateName) ->
  filename = path.resolve __dirname, "../../templates/#{templateName}.jade"
  jade.compile(
    fs.readFileSync(filename),
    { filename: filename }
  )

describe 'SmsView', ->

  before (done) ->
    benv.setup =>
      benv.expose { $: benv.require 'jquery' }
      Backbone.$ = $
      template = render('page')(
        sd:
          ASSET_PATH: 'http://localhost:5000/'
          CSS_EXT: '.css.gz'
          JS_EXT: '.js.gz'
          NODE_ENV: 'test'
      )

      @SmsView = require '../../client/sms_view.coffee'
      @view = new @SmsView el: template
      done()

  beforeEach ->
    sinon.stub $, 'ajax'

  afterEach ->
    $.ajax.restore()

  describe '#submit', ->

    it 'sends a twilio API call upon submit', ->
      @view.$('input.phone_number').val '555 102 2432'
      @view.$('button').trigger 'click'
      $.ajax.args[0][0].type.should.equal 'POST'
      $.ajax.args[0][0].url.should.containEql '/send_link'
      $.ajax.args[0][0].data.phone_number.should.equal '555 102 2432'
