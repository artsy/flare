Backbone = require 'backbone'
_ = require 'underscore'

module.exports = class CarouselView extends Backbone.View

  splashImageAnimationSpeed: 4000

  initialize: (options) ->
    @parent = options.parent
    @$hero = options.$hero
    @animateSplashImages()

  showNextImage: =>
    return unless @parent.heroAnimationsActive

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
