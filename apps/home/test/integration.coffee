{ startServer, closeServer } = require '../../../test/helpers/servers'
Browser = require 'zombie'

describe 'Home page', ->

  before (done) -> startServer done

  after -> closeServer()

  xit 'renders the promo page and lets you submit your phone number', (done) ->
    userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X) AppleWebKit/534.34 (KHTML, like Gecko) PhantomJS/1.9.0 (development) Safari/534.34'
    browser = new Browser
    Browser.visit 'http://localhost:5000', { userAgent: userAgent }, ->
      browser.wait ->
        browser.html().should.containEql 'The art world in your pocket'
        sinon.stub $, 'ajax'
        $('#sms input.phone_number').val('555 102 2432').submit()
        $('#sms button').click()
        $.ajax.args[0][0].url.should.containEql '/send_link'
        $.ajax.args[0][0].data.phone_number.should.equal '555 102 2432'
        done()
