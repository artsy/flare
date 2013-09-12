Backbone = require 'backbone'
_ = require 'underscore'

module.exports = class iPhoneView extends Backbone.View

  minTop: 80
  minLeft: 50

  initialize: ->
    @height = @$el.height()
    @width = @$el.width()
    @$window = $(window)
    @positionPhone()
    @$window.on 'resize.feed', _.debounce((=> @positionPhone()), 300)

  positionPhone: ->
    windowHeight = @$window.height()
    windowWidth = @$window.width()
    top = Math.round((windowHeight - @height) / 2)
    left = Math.round((windowWidth - @width) / 2)

    @top = _.max([top, @minTop])
    @left = _.max([left, @minLeft])

    @$el.css
      top: @top
      left: @left

    @trigger 'repositioned'
