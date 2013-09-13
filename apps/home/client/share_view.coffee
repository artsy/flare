Backbone = require 'backbone'
TwitterShare = require './twitter_share.coffee'
FacebookShare = require './facebook_share.coffee'

module.exports = class ShareView extends Backbone.View

  text: "Share me!"
  url: 'http://iphone.artsy.net'
    
  initialize: ->
    @fbLink = new FacebookShare { el: @$('.facebook-icon') }
    @twitterLink = new TwitterShare { el: @$('.twitter-icon') }

    @fbLink.render $.param({ u: @url })
    @twitterLink.render $.param({ text: @text, url: @url, hideVia: true })
