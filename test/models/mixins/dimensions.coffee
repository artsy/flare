sinon = require 'sinon'
dimensionsMixin = require '../../../models/mixins/dimensions'
fabricate = require '../../helpers/fabricate'
_ = require 'underscore'
Backbone = require 'backbone'

class Model extends Backbone.Model
    
  _.extend @prototype, dimensionsMixin

describe 'Dimensions Mixin', ->
  
  beforeEach ->
    @model = new Model
    
  describe '#dimensions', ->
    
    it 'returns the dimensions chosen by metric', ->
      @model.set metric: 'in', dimensions: { in: 'foobar' }
      @model.dimensions().should.include 'foobar'