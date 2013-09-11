sinon = require 'sinon'
fabricate = require '../../helpers/fabricate'
_ = require 'underscore'
Backbone = require 'backbone'
fetchSetItemsByKey = require '../../../collections/mixins/fetch_set_items_by_key'

class Collection extends Backbone.Collection
    
  _.extend @, fetchSetItemsByKey

  url: 'foo/bar'
  
describe 'fetch set items by key mixin', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @collection = new Collection
  
  afterEach ->
    Backbone.sync.restore()
    
  describe '#fetchSetItemsByKey', ->

    it "fetches the items for the first set by a key", (done) ->
      Collection.fetchSetItemsByKey 'foo:bar', success: (items) ->
        items.first().get('name').should.equal 'FooBar'
        done()
      Backbone.sync.args[0][2].success [
        fabricate('set', id: 'foobar')
        fabricate('set', id: 'bazbar')
      ]
      Backbone.sync.args[1][1].url.should.include 'foobar/items'
      Backbone.sync.args[1][2].success [{ name: 'FooBar' }]
      
    it 'returns an empty collection if there are no sets', (done) ->
      Collection.fetchSetItemsByKey 'foo:bar', success: (items) ->
        items.models.length.should.equal 0
        done()
      Backbone.sync.args[0][2].success []