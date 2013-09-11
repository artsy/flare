sinon = require 'sinon'
rewire = require 'rewire'
redirectToGravity = rewire '../../lib/redirect_to_gravity'
redirectToGravity.__set__ 'GRAVITY_URL', 'http://fakegravityurl.com'
redirectToGravity.__set__ 'REDIRECT_DESKTOP', 'true'

describe '#forUnsupportedRoute', ->
  
  it 'redirects to gravity', ->
    redirectToGravity.forUnsupportedRoute(
      { session: {}, url: '/foo/bar' }, { redirect: spy = sinon.spy() }
    )
    spy.args[0][0].should.equal 'http://fakegravityurl.com/foo/bar'
    
  it 'tells gravity to stop redirecting if getting into a loop', ->
    session = {}
    redirectToGravity.forUnsupportedRoute(
      req = { session: session, url: '/foo/bar' }, { redirect: -> }
    )
    req.session.lastGravityRedirectUrl.should.equal '/foo/bar'
    redirectToGravity.forUnsupportedRoute(
      req = { session: session, url: '/foo/bar' }, { redirect: spy = sinon.spy() }
    )
    spy.args[0][0].toString().should.include "stop_microgravity_redirect=true"
    
describe '#forDesktopBrowser', ->
  
  it 'redirect desktop browsers to gravity', ->
    ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.65 Safari/537.36"
    redirectToGravity.forDesktopBrowser(
      { url: '/foo/bar', headers: { 'user-agent': ua } }, { redirect: spy = sinon.spy() }, ->
    )
    spy.args[0][0].should.equal 'http://fakegravityurl.com/foo/bar'
    
  it 'does not redirect if mobile', ->
    ua = "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3"
    redirectToGravity.forDesktopBrowser(
      { url: '/foo/bar', headers: { 'user-agent': ua } }, { redirect: -> }, nextSpy = sinon.spy()
    )
    nextSpy.called.should.be.ok