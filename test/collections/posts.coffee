sinon = require 'sinon'
Backbone = require 'backbone'
fabricate = require '../helpers/fabricate'
Posts = require '../../collections/posts'

describe 'Posts', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @posts = new Posts [fabricate 'post']
    
  afterEach ->
    Backbone.sync.restore()
  
  describe '@fetchFeatured', ->
    
    it "fetches the first 10 featured posts", (done) ->
      Posts.fetchFeatured success: (posts) ->
        posts.first().get('id').should.equal 'kittens-are-awesome'
        done()
      Backbone.sync.args[0][2].success results: [fabricate 'post', id: 'kittens-are-awesome']