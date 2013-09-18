Backbone = require 'backbone'
_ = require 'underscore'

module.exports = class iPhoneView extends Backbone.View

  minTop: 120
  minLeft: 60
  textWidth: 350
  maxHeight: 807
  phoneHeightToWidthRatio: 0.4733
  phoneContentAreaHeightRatio: 0.7026022
  phoneAreaAboveContentAreaToHeightRatio: 0.147459
  phoneAreaToLeftContentAreaToWidthRatio: 0.083769

  initialize: ->
    @parent = @options.parent
    @$window = @options.$window
    @$phoneContent = @$('.iphone-content')
    @$splashImages = @$('.splash-image')
    @positionPhone()
    @$window.on 'resize.feed', _.throttle((=> @positionPhone()), 70)

  positionPhone: (maxHeight = @maxHeight) ->
    windowHeight = @parent.getHeight()
    windowWidth = @parent.getWidth()

    @height = windowHeight - (@minTop * 2)
    @height = if @height > maxHeight then maxHeight else @height

    @$el.height @height
    @width = Math.floor(@height * @phoneHeightToWidthRatio)

    top = Math.round((windowHeight - @height) / 2)
    left = Math.floor((windowWidth - @width) / 2)

    @top = _.max([top, @minTop])
    @left = _.max([left, @minLeft])

    @$el.css
      top: @top
      left: @left
      width: @width

    @sizeIphoneContentAreas()
    @trigger 'repositioned'

    if @left < @textWidth and windowWidth > @textWidth * 2
      @positionPhone(maxHeight * 0.7)

  sizeIphoneContentAreas: ->
    @contentAreaTop = @height * @phoneAreaAboveContentAreaToHeightRatio
    @contentAreaHeight = @height * @phoneContentAreaHeightRatio

    @$phoneContent.css
      height: @contentAreaHeight
      top: @contentAreaTop

    # ideally this would be sized purely by css but we shrink the container for wipe animations
    @$splashImages.css
      height: @height * @phoneContentAreaHeightRatio
      left: @height * @phoneHeightToWidthRatio * @phoneAreaToLeftContentAreaToWidthRatio
