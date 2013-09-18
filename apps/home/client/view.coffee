Backbone = require 'backbone'
_ = require 'underscore'
BrowseView = require './browse_view.coffee'
ExploreView = require './explore_view.coffee'
CollectView = require './collect_view.coffee'
SmsView = require './sms_view.coffee'
iPhoneView = require './iphone_view.coffee'
ShareView = require './share_view.coffee'

module.exports = class HomePageView extends Backbone.View

  el: 'body'

  headerHeight: 40
  arrowHeight: 40
  headerTextMargin: 45
  heroAnimationsActive: true
  minSupportedWidth: 500
  splashImageAnimationSpeed: 4000

  events:
    'click header .links a' : 'sectionNavClick'
    'click .hero .arrow'    : 'nextSectionClick'

  sections:
    "explore" : (-> new ExploreView(el: $('#explore'), $phoneContentArea: $('.explore-content-area') ) )
    "browse" : (-> new BrowseView(el: $('#browse'), $phoneContentArea: $('.browse-content-area') ) )
    "collect" : (-> new CollectView(el: $('#collect'), $phoneContentArea: $('.collect-content-area') ) )

  sectionViews: {}

  initialize: ->
    @$headerItems = @$('.app-header a')
    @$window = $(window)
    @$document = $(document)
    @$hero = @$('.hero')
    @$arrow = @$hero.find('.arrow-container')
    @$header = @$('.app-header')
    @$largeHeaderText = @$hero.find('.content')
    @$rightHeaders = @$('#content section .right-text')
    @$leftHeaders = @$('#content section .left-text')
    @scrollTop = @$window.scrollTop()
    @isTouchDevice = @isTouchDevice()

    @smsForm = new SmsView(parent: @, el: @$('#sms'), isTouchDevice: @isTouchDevice)
    @iphone = new iPhoneView(parent: @, el: @$('#iphone'), $window: @$window, isTouchDevice: @isTouchDevice)
    @shareView = new ShareView(parent: @, el: @$('.share'))
    @iphone.on 'repositioned', @onResize
    @throttledAnimations = _.throttle((=> @delayableOnScrollEvents()), 70)

    _.defer =>
      @initializeSections()
      @onResize()
      @show()
      @animateSplashImages()
      _.defer =>
        @initializePopLockit() if @browserWidth > @minSupportedWidth
        @newAnimationFrame() if window.requestAnimationFrame

  initializePopLockit: ->
    @$content = $('#content')
    @$content.popLockIt({
      feedItems      : $('#content > section')
      columnSelector : '> .column'
    })
    return @$content?.popLockIt 'destroy' if @isTouchDevice

  initializeSections: ->
    for sectionName in _.keys(@sections)
      @sectionViews[sectionName] = @sections[sectionName]()

  show: ->
    @iphone.$el.addClass 'visible'
    @$header.addClass 'visible'
    @$largeHeaderText.addClass 'visible'

  onResize: =>
    @browserHeight = @getHeight()
    @browserWidth = @getWidth()

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
      'min-height'    : if @isTouchDevice then @browserHeight else (@browserHeight * 1.5)

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
    window?.mixpanel?.track? "click header item '#{section}'"
    false

  smoothTransitionSection: (section) ->
    $section = $("##{section}")
    $('html, body').animate(scrollTop: $section.offset().top, 400)

  showNextImage: =>
    return unless @heroAnimationsActive
    activeSplashImage = @$('.splash-image.active').removeClass('active').next()
    # wait for css fade out animation to finish
    _.delay =>
      unless @$hero.hasClass 'bottom-mode'
        if activeSplashImage.length < 1
          activeSplashImage = @$('.splash-image').first()
        activeSplashImage.addClass 'active'
    , 300

  showFirstSplashImage: ->
    @$('.splash-image.active').removeClass('active')
    @$('.splash-image').first().addClass('active')

  animateSplashImages: -> @splashInterval = window.setInterval @showNextImage, @splashImageAnimationSpeed

  # these events don't need to happen every animation frame
  delayableOnScrollEvents: ->

    # check header position against top of page and bottom of page
    if (@scrollTop > @browserHeight - @headerHeight) and (@scrollTop < @documentHeight - @browserHeight - @headerHeight)
      @$header.addClass('white')
    else
      @$header.removeClass('white')

    # prevent header animations if user has started scrolling
    if @scrollTop < @headerHeight
      @heroAnimationsActive = true
    else
      @heroAnimationsActive = false

    if @scrollTop == @documentHeight - @browserHeight
      @smsForm.focusInput()

    # add / remove the 'bottom mode' state
    if @scrollTop > @documentHeight - (@browserHeight * 2)
      unless @$hero.hasClass 'bottom-mode'
        @$hero.addClass 'bottom-mode'
        @showFirstSplashImage()
    else
      @$hero.removeClass 'bottom-mode'

  animate: =>
    newScrollTop = @$window.scrollTop()
    if newScrollTop != @scrollTop
      direction = if newScrollTop > @scrollTop then 'down' else 'up'
      @scrollTop = newScrollTop

      @throttledAnimations()

      for sectionName, sectionView of @sectionViews
        sectionView.onScroll @scrollTop, @browserHeight, direction

    @newAnimationFrame()

  newAnimationFrame: -> window.requestAnimationFrame @animate

  nextSectionClick: =>
    window?.mixpanel?.track? "clicked down arrow"
    @smoothTransitionSection 'explore'
    return false

  delayShowArrow: ->
    bottom = (@iphone.top / 2) - 10
    _.delay =>
      @$arrow.css
        bottom: bottom
        left: @iphone.left
        width: @iphone.width
      @showArrow()
    , 1000

  showArrow: -> @$arrow.addClass 'active'
  hideArrow: -> @$arrow.remove 'active'

  isTouchDevice: ->
    try
      document.createEvent("TouchEvent")
      return true
    catch
      return false

  getHeight: -> if window.innerHeight then window.innerHeight else @$window.height()
  getWidth: -> if window.innerWidth then window.innerWidth else @$window.width()
