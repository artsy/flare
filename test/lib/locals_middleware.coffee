sinon = require 'sinon'
middleware = require '../../lib/locals_middleware'
sd = require '../../lib/shared_data'

describe 'locals middleware', ->
  
  it 'adds a session id', ->
    middleware req = { session: {} }, res = { locals: {} }, ->
    req.session.id.length.should.be.above 0
    res.locals.bootstrapData.SESSION_ID.should.equal req.session.id

  it 'adds a user agent', ->
    middleware req = { headers: { 'user-agent': 'Artsy-Mobile' } }, res = { locals: {} }, ->
    res.locals.bootstrapData.USER_AGENT.should.equal 'Artsy-Mobile'
    
  it 'adds the shared data', ->
    sd.__foobar = 'boofar'
    middleware req = {}, res = { locals: {} }, ->
    res.locals.bootstrapData.__foobar = 'boofar'
  
describe 'html class generated from user agent', ->
  
  it 'notices the artsy mobile app', ->
    middleware req = { headers: { 'user-agent': 'Artsy-Mobile' } }, res = { locals: {} }, ->
    res.locals.htmlClass.should.equal 'artsy-mobile-app'