Backbone = require 'backbone'
TwitterShare = require './twitter_share.coffee'
FacebookShare = require './facebook_share.coffee'
sd = require '../../../lib/shared_data.coffee'

module.exports = class ShareView extends Backbone.View

  text: "Check out Artsy for iPhone: the art world in your pocket."

  initialize: ->
    @url = sd.CANONICAL_URL

    @fbLink = new FacebookShare { el: @$('.facebook-icon') }
    @twitterLink = new TwitterShare { el: @$('.twitter-icon') }

    @fbLink.render $.param({ u: @url })
    @twitterLink.render $.param({ text: @text, url: @url, hideVia: true })
