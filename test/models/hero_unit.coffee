HeroUnit = require '../../models/hero_unit'
fabricate = require '../helpers/fabricate'

describe 'HeroUnit', ->
  
  beforeEach ->
    @heroUnit = new HeroUnit fabricate 'site_hero_unit'
  
  describe '#cssClass', ->
  
    it 'namespaces some classes based off attrs', ->
      @heroUnit.set mobile_menu_color_class: 'black'
      @heroUnit.cssClass().should.include 'home-page-hero-unit-black'