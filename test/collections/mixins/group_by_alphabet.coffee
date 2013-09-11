sinon = require 'sinon'
fabricate = require '../../helpers/fabricate'
_ = require 'underscore'
Backbone = require 'backbone'
groupByAlphabet = require '../../../collections/mixins/group_by_alphabet'

class Collection extends Backbone.Collection
    
  _.extend @prototype, groupByAlphabet

  url: 'foo/bar'
  
describe 'fetch until end mixin', ->
  
  beforeEach ->
    @collection = new Collection
    
    describe '#grouppedByAlphabet', ->

      it "groups the partners by their sortable id with letters as keys", ->
        @collection.reset [fabricate('partner', sortable_id: 'gago', name: 'The Big Gago')]
        @collection.grouppedByAlphabet()['G'][0].get('name').should.equal 'The Big Gago'