sinon = require 'sinon'
Backbone = require 'backbone'
Profile = require '../../models/profile'
fabricate = require '../helpers/fabricate'

describe 'Profile', ->
  
  beforeEach ->
    @profile = new Profile fabricate 'profile'
    sinon.stub Backbone, 'sync'
    
  afterEach ->
    Backbone.sync.restore() 
    
  describe '#iconUrl', ->
  
    it 'returns an icon image url with :version replaced and .jpg converted', ->
      @profile.set 'icon', { image_url: 'foo/bar/:version.jpg' }
      @profile.iconUrl().should.equal 'foo/bar/square.png'
      
    it 'takes args to choose circle', ->
      @profile.set 'icon', { image_url: 'foo/bar/:version.jpg' }
      @profile.iconUrl('circle').should.equal 'foo/bar/circle.png'
      
  describe '#fetchPosts', ->
    
    beforeEach (done) ->
      @profile.fetchPosts success: (@posts) => done()
      Backbone.sync.args[0][2].success { results: [fabricate 'profile', id: 'foobar'] }
    
    it 'fetches the posts for that profile', ->
      @posts.first().get('id').should.equal 'foobar'
      
    it 'limits to 5', ->
      Backbone.sync.args[0][2].data.size.should.equal 5