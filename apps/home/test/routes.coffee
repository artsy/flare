fabricate = require '../../../test/helpers/fabricate'
sinon = require 'sinon'
routes = require '../routes'
Backbone = require 'backbone'

describe '#index', ->

  beforeEach ->
    sinon.stub Backbone, 'sync'
    routes.index(
      {}
      { render: renderStub = sinon.stub() }
    )
    Backbone.sync.args[0][2].success [
      fabricate 'site_hero_unit', heading: 'Artsy Editorial focus on Kittens'
      fabricate 'site_hero_unit'
    ]
    @templateName = renderStub.args[0][0]
    @templateOptions = renderStub.args[0][1]
      
  afterEach ->
    Backbone.sync.restore()
  
  it 'renders the hero units', ->
    @templateName.should.equal 'page'
    @templateOptions.heroUnits[0].get('heading').should.equal 'Artsy Editorial focus on Kittens'
    
describe '#featuredArtworks', ->

  beforeEach ->
    sinon.stub Backbone, 'sync'
      
  afterEach ->
    Backbone.sync.restore()
  
  it 'renders the featured artworks page', ->
    routes.featuredArtworks {}, { render: renderStub = sinon.stub() }
    Backbone.sync.args[0][2].success fabricate 'set'
    Backbone.sync.args[1][2].success [fabricate 'artwork', title: 'Hello World']
    renderStub.args[0][0].should.equal 'featured_works'
    renderStub.args[0][1].artworks[0].get('title').should.equal 'Hello World'

describe '#featuredPosts', ->

  beforeEach ->
    sinon.stub Backbone, 'sync'
      
  afterEach ->
    Backbone.sync.restore()
  
  it 'renders the featured posts page', ->
    routes.featuredPosts {}, { render: renderStub = sinon.stub() }
    Backbone.sync.args[0][2].success fabricate 'set'
    Backbone.sync.args[1][2].success [fabricate 'post', title: 'Hello World']
    renderStub.args[0][0].should.equal 'featured_posts'
    renderStub.args[0][1].items[0].get('title').should.equal 'Hello World'