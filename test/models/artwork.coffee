sinon = require 'sinon'
Backbone = require 'backbone'
Artwork = require '../../models/artwork'
fabricate = require '../helpers/fabricate'

describe 'Artwork', ->
  
  beforeEach ->
    sinon.stub Backbone, 'sync'
    @artwork = new Artwork fabricate 'artwork'
  
  afterEach ->
    Backbone.sync.restore()
  
  describe '#defaultImageUrl', ->
  
    it 'returns the first medium image url by default', ->
      @artwork.defaultImageUrl().should.match(
        /// /local/additional_images/.*/medium.jpg ///
      )
    
    it 'works if there are no images', ->
      @artwork.set images: []
      @artwork.defaultImageUrl().should.equal ''
      
  describe '#fetchRelatedPosts', ->
    
    it 'it fetches related posts', ->
      @artwork.fetchRelatedPosts()
      Backbone.sync.args[0][1].url.should.include(
        "/api/v1/related/posts?artwork[]=#{@artwork.get 'id'}"
      )
      
  describe '#showPriceLabel', ->
    
    it 'shows the prices label if theres a price, no ediitons, and inquireable', ->
      @artwork.set price: '1000', edition_sets: [], inquireable: true
      @artwork.showPriceLabel().should.be.ok
      
    it 'doesnt shows the prices label if theres no price', ->
      @artwork.set price: null, edition_sets: [], inquireable: false
      @artwork.showPriceLabel().should.not.be.ok
    
    it 'shows the label for artworks that are contact for price', ->
      @artwork.set price: '', sale_message: 'Contact For Price', edition_sets: [], inquireable: true
      @artwork.showPriceLabel().should.be.ok
      
  describe "#showNotForSaleLabel", ->
    
    it 'shows the not for sale label if inquireable and not for sale', ->
      @artwork.set inquireable: true, availability: 'not for sale'
      @artwork.showNotForSaleLabel().should.be.ok
  
  describe '#editionSets', ->
    
    it 'wraps the edition sets in a collection', ->
      @artwork.set edition_sets: [{ foo: 'bar' }]
      @artwork.editionSets().first().get('foo').should.equal 'bar'
      
  describe '#partnerHref', ->
    
    it 'links to collecting institution first', ->
      @artwork.set
        collecting_institution: '[foobar](http://foobar.com)'
        partner:
          profile: fabricate('profile')
      @artwork.partnerHref().should.equal 'http://foobar.com'
      
    it 'links to the profile page second', ->
      @artwork.set
        collecting_institution: null
        partner:
          has_full_profile: true
          default_profile_id: 'foobaz'
      @artwork.partnerHref().should.equal '/foobaz'
      
    it 'links to website last', ->
      @artwork.set
        collecting_institution: null
        partner:
          has_full_profile: false,
          default_profile_id: 'foobaz'
          website: 'moobarz.com'
      @artwork.partnerHref().should.equal 'moobarz.com'
      
    it 'without any collecting_institution, profile page, or website, returns empty string', ->
      @artwork.set
        collecting_institution: null
        partner:
          has_full_profile: null,
          default_profile_id: null
          website: null
      @artwork.partnerHref().should.equal ''
      
  describe '#partnerName', ->
    
    it 'shows parsed markdown collecting institution first', ->
      @artwork.set
        collecting_institution: '[Österreichische Galerie Belvedere, Vienna](http://www.belvedere.at/en)'
      @artwork.partnerName().should.equal("Österreichische Galerie Belvedere, Vienna")