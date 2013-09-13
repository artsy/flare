Backbone = require 'backbone'
_ = require 'underscore'
BrowseView = require './browse_view.coffee'
ExploreView = require './explore_view.coffee'
CollectView = require './collect_view.coffee'
SmsView = require './sms_view.coffee'
iPhoneView = require './iphone_view.coffee'

module.exports = class HomePageView extends Backbone.View
  
  el: 'body'

  headerTextMargin: 60
  phoneContentAreaHeightRatio: 0.7053

  events:
    'click header a' : 'sectionNavClick'
    'click arrow'    : 'nextSectionClick'

  sections:
    "browse" : (-> new BrowseView(parent: @) )
    "explore" : (-> new ExploreView(parent: @) )
    "collect" : (-> new CollectView(parent: @) )

  initialize: ->
    @$headerItems = @$('.app-header a')
    @$window = $(window)
    @$arrow = @$('#arrow')
    @$header = @$('.app-header')
    @$phoneContentAreas = @$('.phone-content-area')
    @$largeHeaderText = @$('.hero .content')
    @$rightHeaders = @$('#content section .right-text')
    @$leftHeaders = @$('#content section .left-text')

    @smsForm = new SmsView(parent: @)
    @iphone = new iPhoneView(parent: @, el: @$('#iphone'))
    @iphone.on 'repositioned', (=> @sizeSections())
    @sizeSections()
    
    _.delay =>
      @show()
      @animateSplashImages()
    , 400

  show: ->
    @iphone.$el.addClass 'visible'
    @$header.addClass 'visible'
    @$largeHeaderText.addClass 'visible'

  sizeSections: ->
    height = @$window.height()
    @$('#content').css(
      'margin-top': "#{height}px"
      'margin-bottom': "#{height}px"
    ).find('section').css
      'min-height': "#{height}px"

    @headerWidth = @$('#content section .left-text').width()

    rightHeaderPosition = @iphone.left + @iphone.width + @headerTextMargin
    leftHeaderPosition = @iphone.left - @headerTextMargin - @headerWidth

    @$largeHeaderText.css
      left: rightHeaderPosition

    @$rightHeaders.css
      left: rightHeaderPosition
    @$leftHeaders.css
      left: leftHeaderPosition

    @$phoneContentAreas.css
      height: @iphone.height * @phoneContentAreaHeightRatio
      'margin-top': @iphone.top + (@iphone.height * 0.14759)

  sectionNavClick: (event) =>
    section = $(event.target).attr 'data-section-name'
    @smoothTransitionSection section

  animateSplashImages: ->
    @splashInterval = window.setInterval =>
      activeSplashImage = @$('.splash-image.active').removeClass('active').next()
      # wait for css fade out animation to finish
      _.delay =>
        if activeSplashImage.length < 1
          activeSplashImage = @$('.splash-image').first()
        activeSplashImage.addClass 'active'
      , 300
    , 2000

  nextSectionClick: =>

  smoothTransitionSection: (section) ->

  showArrow: ->
    @$arrow.show()

  hightlightHeaderSection: ->
    @$headerItems.removeClass 'selected'
