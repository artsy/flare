fabricate = require '../../helpers/fabricate'
_ = require 'underscore'
Backbone = require 'backbone'
dateMixin = require '../../../models/mixins/date'

class Model extends Backbone.Model
    
  _.extend @prototype, dateMixin

describe 'Date Mixin', ->
  
  beforeEach ->
    @model = new Model
    
  describe '#formattedDateRange', ->
    
    it 'formats start_at and end_at', ->
      @model.set start_at: new Date(2000,1,1), end_at: new Date(2000,1,2)
      @model.formattedDateRange().should.equal 'Feb 1st - Feb 2nd'
      
  describe '#fromNow', ->
    
    it 'returns the attribute in from now lingo', ->
      @model.set(start_at: new Date 3000,1,1).fromNow('start_at')
        .should.match /in (.*) years/