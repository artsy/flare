Backbone = require 'backbone'

# base view for video sections
module.exports = class SectionBase extends Backbone.View

  active: false

  initialize: ->
    @$headerLink = $(".links a:eq(#{@index})")

  onResize: (browserHeight) ->
    @top = @$el.offset().top
    @bottom = @top + @$el.height() - browserHeight

  onScroll: (scrollTop, browserHeight)->
    if scrollTop >= @top and scrollTop <= @bottom
      @makeActive()
    else
      @makeInactive()

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
