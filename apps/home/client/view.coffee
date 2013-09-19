Backbone = require 'backbone'
_ = require 'underscore'
BrowseView = require './browse_view.coffee'
ExploreView = require './explore_view.coffee'
CollectView = require './collect_view.coffee'
SmsView = require './sms_view.coffee'
iPhoneView = require './iphone_view.coffee'
ShareView = require './share_view.coffee'
CarouselView = require './carousel_view.coffee'
NavView = require './nav_view.coffee'

module.exports = class HomePageView extends Backbone.View

  el: 'body'

  headerHeight: 40
  arrowHeight: 40
  headerTextMargin: 45
  heroAnimationsActive: true
  minSupportedWidth: 500

  sections:
    "explore" : (-> new ExploreView(el: $('#explore'), $phoneContentArea: $('.explore-content-area') ) )
    "browse" : (-> new BrowseView(el: $('#browse'), $phoneContentArea: $('.browse-content-area') ) )
    "collect" : (-> new CollectView(el: $('#collect'), $phoneContentArea: $('.collect-content-area') ) )

  sectionViews: {}

  initialize: ->
    @$window = $(window)
    @$document = $(document)
    @$hero = @$('.hero')
    @$header = @$('.app-header')
    @$largeHeaderText = @$hero.find('.content')
    @$rightHeaders = @$('#content section .right-text')
    @$leftHeaders = @$('#content section .left-text')
    @scrollTop = @$window.scrollTop()
    @isTouchDevice = @isTouchDevice()

    @smsForm = new SmsView(parent: @, el: @$('#sms'), isTouchDevice: @isTouchDevice)
    @iphone = new iPhoneView(parent: @, el: @$('#iphone'), $window: @$window, isTouchDevice: @isTouchDevice)
    @shareView = new ShareView(parent: @, el: @$('.share'))
    @carouselView = new CarouselView(parent: @, el: @$('.splash-images'), $hero: @$hero)
    @navView = new NavView(parent: @, el: @$el, iphone: @iphone, $arrow: @$hero.find('.arrow-container'))

    @iphone.on 'repositioned', @onResize
    @throttledAnimations = _.throttle((=> @delayableOnScrollEvents()), 70)
    _.defer (=> @render() )

  render: ->
    @initializeSections()
    @onResize()
    @show()
    _.defer =>
      @initializePopLockit() if @browserWidth > @minSupportedWidth
      @newAnimationFrame() if window.requestAnimationFrame

  show: ->
    @iphone.$el.addClass 'visible'
    @$header.addClass 'visible'
    @$largeHeaderText.addClass 'visible'

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

  onResize: =>
    @browserHeight = @getHeight()
    @browserWidth = @getWidth()

    return @$content?.popLockIt 'destroy' if @browserWidth < @minSupportedWidth

    @sizeSections()
    @documentHeight = @$document.height()
    @sizeHeaders()
    @positionHeaders()
    @navView.delayShowArrow()
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
      width: @iphone.left
    @$leftHeaders.css
      width: @iphone.left

  positionHeaders: ->
    browserHeight = @browserHeight
    @$('.text-container').each ->
      $header = $(@)
      $header.css
        'padding-top': (browserHeight - $header.height()) / 2
        'padding-bottom': (browserHeight - $header.height()) / 2

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
      @setHeroBottomMode true
    else
      @setHeroBottomMode false

  # we hide the element then add the class then defer a show.
  # this fixes flickering in safari when modifying covered dom nodes
  setHeroBottomMode: (enabled) ->
    if enabled
      unless @$hero.hasClass 'bottom-mode'
        @$hero.hide().addClass 'bottom-mode'
        _.defer =>
          @$hero.show()
        @carouselView.showFirstSplashImage()

    else if @$hero.hasClass 'bottom-mode'
      @$hero.hide().removeClass 'bottom-mode'
      _.defer =>
        @$hero.show()

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

  isTouchDevice: ->
    try
      document.createEvent("TouchEvent")
      return true
    catch
      return false

  getHeight: -> if window.innerHeight then window.innerHeight else @$window.height()
  getWidth: -> if window.innerWidth then window.innerWidth else @$window.width()
