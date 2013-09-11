sinon = require 'sinon'
Backbone = require 'backbone'
SearchResults = require '../../collections/search_results'
fabricate = require '../helpers/fabricate'

describe 'SearchResults', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @results = new SearchResults [
      fabricate 'artwork', label: 'Artwork'
      fabricate 'artwork', label: 'Artwork'
      fabricate 'artist', label: 'Artist'
    ]
    
  afterEach ->
    Backbone.sync.restore()
  
  describe '#groupped', ->
    
    it 'groups the results by label', ->
      @results.groupped()[0].label.should.equal 'Artists'
      @results.groupped()[0].results.length.should.equal 1
      
    it 'puts artists first', ->
      @results.groupped()[0].label.should.equal 'Artists'
      @results.groupped()[0].results.length.should.equal 1
    
    it 'converts Profile to Partners/Users', ->
      @results.reset [{ label: 'Profile' }]
      @results.groupped()[0].label.should.equal 'Partners/Users'