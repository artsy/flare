Backbone = require 'backbone'
sinon = require 'sinon'
Feature = require '../../models/feature'
fabricate = require '../helpers/fabricate'
_  = require 'underscore'

describe 'Feature', ->
  
  beforeEach ->
    @feature = new Feature fabricate 'feature'
    sinon.stub Backbone, 'sync'
    
  afterEach ->
    Backbone.sync.restore()
    
  describe '#imageUrl', ->
  
    it 'returns nothing if missing image', ->
      @feature.set image_url: 'missing_image.png'
      (@feature.imageUrl()?).should.not.be.ok
      
  describe '#fetchItems', ->
    
    it 'collects the items into an array of helpful hashes', (done) ->
      @feature.fetchItems success: (items) ->
        items[0].type.should.equal 'featured links'
        items[0].title.should.equal 'Explore this bidness'
        items[0].data.first().get('title').should.equal 'Featured link for this awesome page'
        done()
      _.last(Backbone.sync.args)[2].success([fabricate 'set', name: 'Explore this bidness'])
      _.last(Backbone.sync.args)[2].success([
        fabricate 'featured_link', title: 'Featured link for this awesome page'
      ])
      
    it 'orders the items properly', (done) ->
      @feature.fetchItems success: (items) ->
        items[0].type.should.equal 'featured links'
        items[1].type.should.equal 'sale artworks'
        done()
      Backbone.sync.args[0][2].success([
          fabricate 'set', item_type: 'FeaturedLink'
          fabricate 'set', item_type: 'Sale'
        ])
      Backbone.sync.args[1][2].success([fabricate 'sale'])
      Backbone.sync.args[2][2].success([fabricate 'featured_link'])
      Backbone.sync.args[3][2].success([fabricate 'sale_artwork'])
      
  it 'gives back sale artworks', (done) ->
    @feature.fetchItems success: (items) ->
      items[0].data.first().get('title').should.equal 'Portrait of a Mouse'
      done()
    Backbone.sync.args[0][2].success([
        fabricate 'set', item_type: 'Sale'
      ])
    Backbone.sync.args[1][2].success([fabricate 'sale'])
    Backbone.sync.args[2][2].success([
      fabricate('sale_artwork', artwork: fabricate('artwork', title: 'Portrait of a Mouse'))
    ])