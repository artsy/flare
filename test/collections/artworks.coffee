sinon = require 'sinon'
Backbone = require 'backbone'
fabricate = require '../helpers/fabricate'
Artworks = require '../../collections/artworks'

describe 'Artworks', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @posts = new Artworks [fabricate 'post']
    
  afterEach ->
    Backbone.sync.restore()
  
  describe '@fromSale', ->
    
    it "returns sale info inject in artworks", ->
      artworks = Artworks.fromSale new Backbone.Collection [{
        artwork: fabricate 'artwork'
        user_notes: "The vomit on this canvas is truely exquisit."
      }] 
      artworks.first().get('saleInfo.user_notes').should.include 'vomit'
      
    it "sorts by position", ->
      artworks = Artworks.fromSale new Backbone.Collection [
        { artwork: fabricate('artwork', title: 'b'), position: 2 }
        { artwork: fabricate('artwork', title: 'a'), position: 1 }
        { artwork: fabricate('artwork', title: 'c'), position: 3 }
      ]
      artworks.pluck('title').join('').should.equal 'abc'