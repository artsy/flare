servers = require '../../../test/helpers/servers'
Browser = require 'zombie'
sinon = require 'sinon'

describe 'Home page', ->
  
  before (done) ->
    servers.setup -> done()
  
  after ->
    servers.teardown()
  
  it 'renders the promo page and lets you submit your phone number', (done) ->
    Browser.visit 'http://localhost:5000', (e, browser) ->
      $ = browser.window.$
      browser.html().should.include 'The art world in your pocket'
      sinon.stub $, 'ajax'
      $('#sms input.phone_number').val('555 102 2432').submit()
      $('#sms button').click()
      $.ajax.args[0][0].url.should.include '/send_link'
      $.ajax.args[0][0].data.phone_number.should.equal '555 102 2432'
      done()
      