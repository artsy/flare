clientenv = require '../helpers/clientenv'
sd = require '../../lib/shared_data.coffee'
servers = require '../helpers/servers'
Browser = require 'zombie'

describe 'Bootstrapping client-side environment', ->

  before (done) ->
    clientenv.setup ->
      BOOTSTRAP.GRAVITY_URL = 'foobar'
      BOOTSTRAP['GRAVITY_XAPP_TOKEN'] = 'xappfoobar'
      require('../../components/layout/bootstrap')()
      done()

  it 'loads any bootstrap data into the shared data hash', ->
    sd.GRAVITY_URL.should.equal 'foobar'
    
  it 'adds the XAPP token to ajax requests', ->
    $.ajaxSettings.headers['X-XAPP-TOKEN'].should.equal 'xappfoobar'

describe 'Html class from user agent', ->
  
  before (done) ->
    servers.setup -> done()
  
  after ->
    servers.teardown()
  
  it 'adds the hide header/footer artsy-mobile class to the html tag', (done) ->
    browser = new Browser(userAgent: 'Artsy-Mobile')
    browser.visit 'http://localhost:5000/artwork/foo', ->
      browser.wait ->
        browser.querySelector('html').className.should.include 'artsy-mobile-app'
        done()