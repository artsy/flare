Backbone = require 'backbone'

# base view for video sections
module.exports = class SectionBase extends Backbone.View

  contentAreaActive: false
  active: false
  state: {}
  cssProperties: ['height', 'top', 'bottom', 'padderPositionTop']

  initialize: ->
    @$headerLink = $(".links a:eq(#{@index})")
    @$phoneContentArea = @options.$phoneContentArea
    @$phoneContentPadder = @$phoneContentArea.find('.content-padder')
    @parent = @options.parent

  onResize: (browserHeight, phoneContentAreaTop, phoneContentAreaHeight, phoneTop) ->
    @top = @$el.offset().top
    @activeTop = @top - browserHeight

    @bottom = @top + @$el.height()
    @activeBottom = @bottom - browserHeight

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
    @contentAreaOnScroll scrollTop, browserHeight

  contentAreaOnScroll: (scrollTop, browserHeight) ->
    height = @contentHeight
    top = 0
    bottom = 'auto'
    backgroundPositionY = 'auto'

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

      @makeContentAreaActive()
    else
      @makeContentAreaInactive()

    # clean up the data
    height = if height < 0 then 0 else height
    height = if height > @contentHeight then @contentHeight else height

    newState =
      height: "#{height}px"
      top: top
      bottom: bottom
      padderPositionTop: height - @contentHeight
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

      # bit of a hack - refactor
      if @state.top
        @$phoneContentPadder.css top: @state.padderPositionTop

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
