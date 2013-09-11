Backbone = require 'backbone'
FeaturedLinks = require '../../../collections/featured_links.coffee'
ShowsFeed = require '../../../collections/shows_feed.coffee'
featuredItemsTemplate = -> require('../../../components/featured_items/template.jade') arguments...
currentShowsTemplate = -> require('../templates/current_shows.jade') arguments...
artworkColumnsTemplate = -> require('../../../components/artwork_columns/template.jade') arguments...

module.exports = class HomePageView extends Backbone.View
  
  el: 'body'
    
  initialize: ->
    @shows = new ShowsFeed
    @$el.infiniteScroll @shows.nextPage
    @shows.on 'sync', @renderCurrentShows
    @shows.fetch()
    setInterval @showNextHeroUnit, 4000
  
  renderCurrentShows: =>
    @$('#home-page-current-shows').html currentShowsTemplate(
      shows: @shows.models
      artworkColumnsTemplate: artworkColumnsTemplate
    )
    @$('.artwork-columns').removeColumnSpace()
  
  events:
    'click #home-page-hero-unit-dots a': 'swapHeroUnit'
    'swipeLeft #home-page-hero-units': 'showNextHeroUnit'
    'swipeRight #home-page-hero-units': 'showPrevHeroUnit'
  
  showNextHeroUnit: =>
    $next = @$('.home-page-hero-unit-dot-active').next()
    $el = if $next.length then $next else @$('#home-page-hero-unit-dots a').first()
    @swapHeroUnit target: $el
    
  showPrevHeroUnit: =>
    $prev = @$('.home-page-hero-unit-dot-active').prev()
    $el = if $prev.length then $prev else @$('#home-page-hero-unit-dots a').last()
    @swapHeroUnit target: $el
  
  swapHeroUnit: (e) ->
    @$('#home-page-hero-units li').hide().eq($(e.target).index()).show()
    @$('.home-page-hero-unit-dot-active').removeClass('home-page-hero-unit-dot-active')
    $(e.target).addClass('home-page-hero-unit-dot-active')
    false