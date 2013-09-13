Backbone = require 'backbone'
_ = require 'underscore'

module.exports = class WhiteBlockerBars extends Backbone.View

  cssProperties: ['top', 'height']

  state:
    top: 0
    height: 0
    
  topPadding: 15

  initialize: ->
    @parent = @options.parent
    @$whiteBars = @$('.white-bar')

  size: (width, left, top, height)->
    @$el.css
      width: "#{width - 40}px"
      left: "#{left + 20}px"
      height: "#{height}px"

    @margin = top + @topPadding

    @$whiteBars.css
      height: "#{@margin}px"

    # rather than being positioned at the bottom, the bottom bar is
    # pushed down using a margin. This way, when we change the height
    # of the container it stays in the same position and is hidden
    # (overflow: hidden) and does not rise with the bottom of the
    # container.
    @$('.bottom-white-bar').css
      'margin-top': @parent.browserHeight - (@margin * 2)

  onScroll: (scrollTop) ->
    # user is 'in the middle' of the page
    if scrollTop > @parent.browserHeight and scrollTop < @parent.documentHeight - (@parent.browserHeight * 2)
      top = 0
      height = @parent.browserHeight

    # user is towards the bottom of the page
    else if scrollTop > @parent.documentHeight - (@parent.browserHeight * 2)
      top = 0
      height = @parent.documentHeight - scrollTop - @parent.browserHeight - 1

    # user is towards the top of the page
    else
      height = @parent.browserHeight
      top = @margin
      if @parent.browserHeight - scrollTop < @margin
        top = @parent.browserHeight - scrollTop
        height = @parent.browserHeight
      else
        top = @parent.browserHeight - scrollTop
        top = if top < @parent.browserHeight - @margin then @parent.browserHeight - @margin else top
        skipValidation = true

    unless skipValidation
      top = if top < - @margin then - @margin else top
      top = if top > @margin then @margin else top
      height = if height > @parent.browserHeight then @parent.browserHeight else height

    newState =
      top: "#{top}px"
      height: "#{height}px"

    @applyNewState newState

  applyNewState: (newState) ->
    diff = {}
    changed = false
    for prop in @cssProperties
      if newState[prop] != @state[prop]
        diff[prop] = newState[prop]
        changed = true

    if changed
      @$el.css(diff).show()
      @state = newState
