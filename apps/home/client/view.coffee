Backbone = require 'backbone'
_ = require 'underscore'
BrowseView = require './browse_view.coffee'
ExploreView = require './explore_view.coffee'
CollectView = require './collect_view.coffee'
SmsView = require './sms_view.coffee'
iPhoneView = require './iphone_view.coffee'
ShareView = require './share_view.coffee'

# todo - refactor this into a larger view for the homepage / app and a subview for stuff under #content
module.exports = class HomePageView extends Backbone.View

  el: 'body'

  headerHeight: 40
  arrowHeight: 40
  headerTextMargin: 45
  heroAnimationsActive: true
  minSupportedWidth: 770

  events:
    'click header .links a' : 'sectionNavClick'
    'click .hero .arrow'    : 'nextSectionClick'

  sections:
    "browse" : (-> new BrowseView(el: $('#browse'), $phoneContentArea: $('.browse-content-area') ) )
    "explore" : (-> new ExploreView(el: $('#explore'), $phoneContentArea: $('.explore-content-area') ) )
    "collect" : (-> new CollectView(el: $('#collect'), $phoneContentArea: $('.collect-content-area') ) )

  sectionViews: {}

  initialize: ->
    @$headerItems = @$('.app-header a')
    @$window = $(window)
    @$document = $(document)
    @$arrow = @$('.hero .arrow')
    @$header = @$('.app-header')
    @$largeHeaderText = @$('.hero .content')
    @$rightHeaders = @$('#content section .right-text')
    @$leftHeaders = @$('#content section .left-text')
    @scrollTop = @$window.scrollTop()

    @smsForm = new SmsView(parent: @, el: @$('#sms'))
    @iphone = new iPhoneView(parent: @, el: @$('#iphone'), $window: @$window)
    @shareView = new ShareView(parent: @, el: @$('.share'))
    @iphone.on 'repositioned', @onResize

    _.delay =>
      @initializeSections()
      @onResize()
      @show()
      @animateSplashImages()
      _.defer =>
        @initializePopLockit() if @browserWidth > @minSupportedWidth
        @newAnimationFrame()
    , 400

  initializePopLockit: ->
    @$content = $('#content')
    @$content.popLockIt({
      feedItems      : $('#content > section')
      columnSelector : '> .column'
    })

  initializeSections: ->
    for sectionName in _.keys(@sections)
      @sectionViews[sectionName] = @sections[sectionName]()

  show: ->
    @iphone.$el.addClass 'visible'
    @$header.addClass 'visible'
    @$largeHeaderText.addClass 'visible'

  onResize: =>
    @browserHeight = @$window.height()
    @browserWidth = @$window.width()

    return @$content?.popLockIt 'destroy' if @browserWidth < @minSupportedWidth

    @sizeSections()
    @documentHeight = @$document.height()
    @sizeHeaders()
    @positionHeaders()
    @delayShowArrow()
    for sectionName, sectionView of @sectionViews
        sectionView.onResize @browserHeight, @iphone.contentAreaTop, @iphone.contentAreaHeight, @iphone.top
    @$content?.popLockIt 'recompute'

  sizeSections: ->
    @$('#content').css(
      'margin-top'    : @browserHeight
      'margin-bottom' : @browserHeight
    ).find('section').css
      'min-height'    : @browserHeight * 1.5

  sizeHeaders: ->
    @headerWidth = @$('#content section .left-text').width()

    @$largeHeaderText.css
      left: @iphone.left + @iphone.width + @headerTextMargin

    @$rightHeaders.css
      width: "#{@iphone.left}px"
    @$leftHeaders.css
      width: "#{@iphone.left}px"

  positionHeaders: ->
    browserHeight = @browserHeight
    @$('.text-container').each ->
      $header = $(@)
      $header.css
        'padding-top': (browserHeight - $header.height()) / 2
        'padding-bottom': (browserHeight - $header.height()) / 2

  sectionNavClick: (event) =>
    event.preventDefault()
    section = $(event.target).attr 'data-section-name'
    @smoothTransitionSection section
    false

  smoothTransitionSection: (section) ->
    $section = $("##{section}")
    $('html, body').animate(scrollTop: $section.offset().top, 400)

  showNextImage: =>
    return unless @heroAnimationsActive
    activeSplashImage = @$('.splash-image.active').removeClass('active').next()
    # wait for css fade out animation to finish
    _.delay =>
      if activeSplashImage.length < 1
        activeSplashImage = @$('.splash-image').first()
      activeSplashImage.addClass 'active'
    , 300

  animateSplashImages: -> @splashInterval = window.setInterval @showNextImage, 3000

  animate: =>
    newScrollTop = @$window.scrollTop()
    if newScrollTop != @scrollTop
      direction = if newScrollTop > @scrollTop then 'down' else 'up'
      @scrollTop = newScrollTop

      # check header position against top of page and bottom of page
      if (@scrollTop > @browserHeight - @headerHeight) and (@scrollTop < @documentHeight - @browserHeight - @headerHeight)
        @$header.addClass('white')
      else
        @$header.removeClass('white')

      # prevent header animations if user has started scrolling
      # re-enable header animations if they are at the bottom of the page
      if (@scrollTop > @headerHeight) and (@scrollTop < @documentHeight - @browserHeight - (@headerHeight * 2))
        @heroAnimationsActive = false
      else
        @heroAnimationsActive = true

      for sectionName, sectionView of @sectionViews
        sectionView.onScroll @scrollTop, @browserHeight, direction

    @newAnimationFrame()

  newAnimationFrame: -> window.requestAnimationFrame @animate

  nextSectionClick: =>
    @smoothTransitionSection 'browse'
    return false

  delayShowArrow: ->
    bottom = (@iphone.top / 2)
    _.delay =>
      @$arrow.css(
        bottom: bottom
      ).addClass 'active'
    , 1000


  hightlightHeaderSection: ->
    @$headerItems.removeClass 'selected'
