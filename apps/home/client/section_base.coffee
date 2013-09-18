Backbone = require 'backbone'

# base view for video sections
module.exports = class SectionBase extends Backbone.View

  supportsHtml5Video: true
  contentAreaActive: false
  active: false
  state: {}
  cssProperties: ['height', 'top', 'bottom', 'padderPositionTop', 'padderOpacity']

  initialize: ->
    @$headerLink = $(".links a:eq(#{@index})")
    @$phoneContentArea = @options.$phoneContentArea
    @$phoneContentPadder = @$phoneContentArea.find('.content-padder')
    @$video = @$phoneContentArea.find('video')
    if @$video.length
      @video = @$video.show()[0]
    @parent = @options.parent
    @detectHtml5VideoSupport()
    unless @supportsHtml5Video
      @displayFallbackImage()

  displayFallbackImage: ->
    @$video.remove()
    @$phoneContentArea.find('img').show()

  onResize: (browserHeight, phoneContentAreaTop, phoneContentAreaHeight, phoneTop) ->
    @top = @$el.offset().top
    @activeTop = @top - browserHeight
    @videoTop = @top - (browserHeight / 5)

    @bottom = @top + @$el.height()
    @activeBottom = @bottom - browserHeight
    @videoBottom = @bottom - browserHeight + (browserHeight / 5)

    # for the phone content areas
    @contentTopMargin = phoneContentAreaTop + phoneTop
    @contentHeight = phoneContentAreaHeight

    @phoneTop = @top + @contentTopMargin
    @phoneActiveTop = @activeTop + @contentTopMargin

    @phoneBottom = @bottom - @contentTopMargin
    @phoneActiveBottom = @activeBottom - @contentTopMargin

  onScroll: (scrollTop, browserHeight)->
    if scrollTop >= @top and scrollTop <= @activeBottom
      @makeActive()
    else
      @makeInactive()

    if scrollTop > @videoTop and scrollTop < @videoBottom
      @playVideo()
    else
      @pauseVideo()

    @contentAreaOnScroll scrollTop, browserHeight

  contentAreaOnScroll: (scrollTop, browserHeight) ->
    height = @contentHeight
    top = 0
    bottom = 'auto'
    backgroundPositionY = 'auto'
    opacity = 1

    if scrollTop > @phoneActiveTop && scrollTop < @phoneBottom

      # this section is below the current section
      if scrollTop >= @phoneActiveTop && scrollTop <= @phoneTop
        height = scrollTop - @phoneActiveTop
        top = 'auto'
        bottom = 0

      # this section is above the current section
      else if scrollTop >= @phoneActiveBottom && scrollTop <= @phoneBottom
        height = @phoneBottom - scrollTop
        top = 0
        bottom = 'auto'
        opacity = ((height * 1.5) / @contentHeight)

      @makeContentAreaActive()
    else
      @makeContentAreaInactive()

    # clean up the data
    height = if height < 0 then 0 else height
    height = if height > @contentHeight then @contentHeight else height

    newState =
      height: Math.round(height)
      top: top
      bottom: bottom
      padderPositionTop: Math.round(height - @contentHeight)
      padderOpacity: opacity
    @applyNewState newState

  # ensure we don't make any unnecessary dom manipulation
  applyNewState: (newState) ->
    diff = {}
    changed = false
    for prop in @cssProperties
      if newState[prop] != @state[prop]
        diff[prop] = newState[prop]
        changed = true

    if changed
      @$phoneContentArea.css(diff).show()
      @state = newState

      @$video.css
        opacity: @state.padderOpacity

      # bit of a hack - refactor
      if @state.top
        @$phoneContentPadder.css
          top: @state.padderPositionTop

  playVideo: ->
    if @supportsHtml5Video and @video and !@playing
      @video.play()
      window?.mixpanel?.track? "playing video number #{@index}"
      @playing = true

  pauseVideo: ->
    if @video and @playing
      @playing = false
      @video.pause()

  makeActive: ->
    return if @active
    @$headerLink.addClass 'active'
    @$el.addClass 'active'
    @active = true

  makeInactive: ->
    return unless @active
    @$headerLink.removeClass 'active'
    @$el.removeClass 'active'
    @active = false

  makeContentAreaActive: ->
    return if @contentAreaActive
    @$phoneContentArea.addClass 'active'
    @contentAreaActive = true

  makeContentAreaInactive: ->
    return unless @contentAreaActive
    @$phoneContentArea.removeClass 'active'
    @contentAreaActive = false

  # Html5 video performes terribly on Safari (unable to scroll while video is playing) so we disable it ONLY in Safari
  # CSS fallbacks are apropriate for other browsers
  detectHtml5VideoSupport: ->
    @supportsHtml5Video = !!document.createElement('video').canPlayType
    if @supportsHtml5Video
      isChrome = navigator.userAgent.indexOf('Chrome') > -1
      isSafari = navigator.userAgent.indexOf("Safari") > -1
      if isChrome and isSafari
        isSafari = false
      @supportsHtml5Video = false if isSafari
