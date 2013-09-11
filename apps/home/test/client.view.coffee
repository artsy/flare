Backbone = require 'backbone'
HeroUnits = require '../../../collections/hero_units'
fabricate = require '../../../test/helpers/fabricate'
clientenv = require '../../../test/helpers/clientenv'
sinon = require 'sinon'

describe 'HomePageView', ->

  before (done) ->
    clientenv.prepare '../client/view', module,
      serverTemplate:
        filename: '../templates/page.jade'
        locals:
          heroUnits: new HeroUnits([
            fabricate 'site_hero_unit'
            fabricate 'site_hero_unit'
            fabricate 'site_hero_unit'
          ]).models
          sd: {}
      clientTemplates: ['featuredItemsTemplate', 'currentShowsTemplate', 'artworkColumnsTemplate']
      done: (@HomePageView) => done()
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @view = new @HomePageView
    Backbone.sync.restore()
    sinon.stub Backbone, 'sync'
    
  afterEach ->
    Backbone.sync.restore()
  
  describe '#initialize', ->
    
    it 'renders shows on sync', ->
      @view.renderCurrentShows = sinon.stub()
      @view.initialize()
      @view.shows.trigger 'sync'
      @view.renderCurrentShows.called.should.be.ok
  
  describe '#renderCurrentShows', ->
    
    it 'renders the current shows', ->
      @view.shows.reset [
        fabricate 'show', name: 'Kittens on the wall'
      ]
      @view.renderCurrentShows()
      @view.$el.html().should.include 'Kittens on the wall'
  
  describe '#swapHeroUnit', ->
    
    it 'changes the visible hero unit', ->
      spy = sinon.spy $.fn, 'show'
      $('#home-page-hero-unit-dots a').last().click()
      spy.called.should.be.ok
      
  describe '#showNextHeroUnit', ->
    
    it 'shows the next hero unit', ->
      spy = sinon.spy @view, 'swapHeroUnit'
      @view.showNextHeroUnit()
      spy.args[0][0].target.index().should.equal 0
      
  describe '#showPrevHeroUnit', ->
    
    it 'shows the previous hero unit', ->
      spy = sinon.spy @view, 'swapHeroUnit'
      @view.showPrevHeroUnit()
      spy.args[0][0].target.index().should.equal 2