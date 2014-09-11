errorHandler = require '../../components/error_handler'
sinon = require 'sinon'

describe '#internalError', ->

  it 'renders a 500 page', ->
    errorHandler.internalError "Some blah error", {}, { send: spy = sinon.spy() }
    spy.args[0][0].should.equal 500
    spy.args[0][1].should.containEql "Some blah error"

describe '#pageNotFound', ->

  it 'renders a 404 page', ->
    errorHandler.pageNotFound {}, { send: spy = sinon.spy() }
    spy.args[0][0].should.equal 404
    spy.args[0][1].should.containEql "Page not found"
