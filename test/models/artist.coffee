sinon = require 'sinon'
Backbone = require 'backbone'
Artist = require '../../models/artist'
fabricate = require '../helpers/fabricate'

describe 'Artist', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @artist = new Artist fabricate 'artist'
  
  afterEach ->
    Backbone.sync.restore()
  
  describe '#imageUrl', ->
  
    it 'returns the replaced image url', ->
      @artist.set image_url: 'foo/bar/:version.jpg'
      @artist.imageUrl().should.equal 'foo/bar/medium.jpg'
      
  describe '#fetchArtworks', ->
    
    it 'fetches the artists artworks', (done) ->
      @artist.fetchArtworks success: (artworks) ->
        artworks.first().get('title').should.equal 'Arrghwork'
        done()
      Backbone.sync.args[0][2].success [fabricate 'artwork', title: 'Arrghwork']
      Backbone.sync.args[0][1].url.should.match /// /api/v1/artist/.*/artworks ///
      
  describe '#fetchRelatedPosts', ->
    
    it 'fetches the artists artworks', (done) ->
      @artist.fetchRelatedPosts success: (posts) ->
        posts.first().get('title').should.equal 'We all Love Andy Foobar'
        done()
      Backbone.sync.args[0][2].success [fabricate 'post', title: 'We all Love Andy Foobar']
      Backbone.sync.args[0][1].url.should.include 'artist[]=' + @artist.get('id')
      
  describe '#fetchRelatedArtists', ->
    
    it 'fetches the related artists', (done) ->
      @artist.fetchRelatedArtists success: (artists) ->
        artists.first().get('name').should.equal "Andy Bazqux"
        done()
      Backbone.sync.args[0][2].success [fabricate 'artist', name: 'Andy Bazqux']
      Backbone.sync.args[0][1].url.should.include 'layer/main/artists'