sinon = require 'sinon'
Backbone = require 'backbone'
Show = require '../../models/show'
fabricate = require '../helpers/fabricate'

describe 'Show', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @show = new Show fabricate 'show'
  
  afterEach ->
    Backbone.sync.restore()
  
  describe '#formattedDateRange', ->
  
    it 'formates the date range of the show', ->
      @show.formattedDateRange().should.equal 'Jan 7th - Feb 4th'
      
  describe '#artworks', ->
    
    it 'wraps the artworks in a collection', ->
      @show.set artworks: [fabricate 'artwork', title: 'Foobar']
      @show.artworks().first().get('title').should.equal 'Foobar'
    
  describe '#feedHeader', ->
    
    it 'shows the fair name if its a fair', ->
      @show.set fair: { name: 'foobar' }
      @show.feedHeader().should.equal 'foobar'
      
    it 'shows the artist name if no show name and no fair', ->
      @show.set(
        artists: [fabricate('artist', name: 'foo'), fabricate('artist', name: 'bar')]
        name: ''
      )
      @show.feedHeader().should.equal 'foo, bar'
      
  describe '#feedSubheaderAppend', ->
    
    it 'shows the fair location if a fair booth', ->
      @show.set fair: {}, fair_location: { display: 'foo at the bar' }
      @show.feedSubheaderAppend().should.equal 'foo at the bar'
      
    it 'shows the location city if not at a fair', ->
      @show.set location: { city: 'Cincinnati' }, fair: null
      @show.feedSubheaderAppend().should.equal 'Cincinnati'
      
  describe '#formattedLocation', ->
    
    it 'gives the fair name if its a fair booth', ->
      @show.set fair: fabricate('fair', name: 'The Foobar Show')
      @show.formattedLocation().should.equal 'The Foobar Show'
      
    it 'gives the city and address if not a fair', ->
      @show.set location: { city: 'Cincinnati', address: 'Spinningwheel Ln.' }
      @show.formattedLocation().should.equal 'Cincinnati, Spinningwheel Ln.'
      
  describe '#fetchArtworks', ->
    
    it 'fetches the shows artworks', (done) ->
      @show.fetchArtworks success: (artworks) ->
        artworks.first().get('title').should.equal 'FooBarBaz'
        done()
      Backbone.sync.args[0][1].url.should.include "show/#{@show.get 'id'}/artworks"
      Backbone.sync.args[0][2].success [fabricate 'artwork', title: 'FooBarBaz']