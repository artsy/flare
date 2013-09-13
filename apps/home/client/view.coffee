Backbone = require 'backbone'
_ = require 'underscore'
BrowseView = require './browse_view.coffee'
ExploreView = require './explore_view.coffee'
CollectView = require './collect_view.coffee'
SmsView = require './sms_view.coffee'
iPhoneView = require './iphone_view.coffee'

module.exports = class HomePageView extends Backbone.View

  el: 'body'

  headerHeight: 64
  headerTextMargin: 60
  phoneContentAreaHeightRatio: 0.7053
  phoneAreaAboveContentAreaToHeightRatio: 0.14759
  # each variable name must be longer than previous one

  events:
    'click header a' : 'sectionNavClick'
    'click arrow'    : 'nextSectionClick'

  sections:
    "browse" : (-> new BrowseView(parent: @) )
    "explore" : (-> new ExploreView(parent: @) )
    "collect" : (-> new CollectView(parent: @) )
  sectionViews: {}

  initialize: ->
    @$headerItems = @$('.app-header a')
    @$window = $(window)
    @$document = $(document)
    @$arrow = @$('#arrow')
    @$header = @$('.app-header')
    @$phoneContentAreas = @$('.phone-content-area')
    @$largeHeaderText = @$('.hero .content')
    @$rightHeaders = @$('#content section .right-text')
    @$leftHeaders = @$('#content section .left-text')

    @smsForm = new SmsView(parent: @)
    @iphone = new iPhoneView(parent: @, el: @$('#iphone'))
    @iphone.on 'repositioned', (=> @onResize() )

    _.delay =>
      @onResize()
      @show()
      @animateSplashImages()
      @startAnimationFrame()
      @initializeSections()
    , 400

  initializeSections: ->
    for sectionName in _.keys(@sections)
      @sectionViews[sectionName] = @sections[sectionName]()

  show: ->
    @iphone.$el.addClass 'visible'
    @$header.addClass 'visible'
    @$largeHeaderText.addClass 'visible'

  onResize: ->
    @browserHeight = @$window.height()
    @sizeSections()
    @documentHeight = @$document.height()
    @sizeHeaders()
    @positionHeaders()
    @sizeIphoneContentAreas()

  sizeSections: ->
    @$('#content').css(
      'margin-top'    : "#{@browserHeight}px"
      'margin-bottom' : "#{@browserHeight}px"
    ).find('section').css
      'min-height'    : "#{@browserHeight * 3}px"

  sizeHeaders: ->
    @headerWidth = @$('#content section .left-text').width()

    rightHeaderPosition = @iphone.left + @iphone.width + @headerTextMargin
    leftHeaderPosition = @iphone.left - @headerTextMargin - @headerWidth

    @$largeHeaderText.css
      left: rightHeaderPosition

    @$rightHeaders.css
      left: rightHeaderPosition
    @$leftHeaders.css
      left: leftHeaderPosition

  positionHeaders: ->
    browserHeight = @browserHeight
    @$('.text-container').each ->
      $header = $(@)
      $header.css
        top: (browserHeight - $header.height()) / 2

  sizeIphoneContentAreas: ->
    @$phoneContentAreas.css
      height: @iphone.height * @phoneContentAreaHeightRatio

    # todo - refactor
    @contentAreaTop = @iphone.top + (@iphone.height * @phoneAreaAboveContentAreaToHeightRatio)
    $('.phone-content-area.splash-images').css
      'margin-top': @contentAreaTop

  sectionNavClick: (event) =>
    event.preventDefault()
    section = $(event.target).attr 'data-section-name'
    @smoothTransitionSection section
    false

  smoothTransitionSection: (section) ->
    $section = $("##{section}")
    $('html, body').animate(scrollTop: $section.offset().top, 400)

  animateSplashImages: ->
    @splashInterval = window.setInterval =>
      activeSplashImage = @$('.splash-image.active').removeClass('active').next()
      # wait for css fade out animation to finish
      _.delay =>
        if activeSplashImage.length < 1
          activeSplashImage = @$('.splash-image').first()
        activeSplashImage.addClass 'active'
      , 300
    , 3000

  startAnimationFrame: ->
    @scrollTop = @$window.scrollTop()

    step = =>
      newScrollTop = @$window.scrollTop()
      if newScrollTop != @scrollTop
        direction = if newScrollTop > @scrollTop then 'down' else 'up'
        @scrollTop = newScrollTop

        # check header position against top of page and bottom of page
        if (@scrollTop > @browserHeight - @headerHeight) and (@scrollTop < @documentHeight - @browserHeight - @headerHeight)
          @$header.addClass('white')
        else
          @$header.removeClass('white')

        for sectionName, sectionView of @sectionViews
          sectionView.onScroll @scrollTop, @browserHeight, direction

      window.requestAnimationFrame step

    window.requestAnimationFrame step

  nextSectionClick: =>

  showArrow: ->
    @$arrow.show()

  hightlightHeaderSection: ->
    @$headerItems.removeClass 'selected'
