clientenv = require '../helpers/clientenv'
sd = require '../../lib/shared_data.coffee'
servers = require '../helpers/servers'
Browser = require 'zombie'

describe 'Bootstrapping client-side environment', ->

  before (done) ->
    clientenv.setup ->
      require('../../components/layout/bootstrap')()
      done()

  it 'adds the XAPP token to ajax requests', ->
    $.ajaxSettings.headers['X-XAPP-TOKEN'].should.equal 'xappfoobar'
