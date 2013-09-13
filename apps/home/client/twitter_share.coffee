Backbone = require 'backbone'

module.exports = class TwitterShare extends Backbone.View

  events:
    "click" : "share"

  render: (params) ->
    @$el.attr
      href: "http://twitter.com/share?#{params}"

  share: ->
    width   = 575
    height  = 400
    toolbar = 0
    left    = ($(window).width()  - width) / 2
    top     = ($(window).height() - height) / 2
    opts    = "status=1,width=#{width},height=#{height},top=#{top},left=#{left}"
    window.open @$el.attr('href'), 'twitter', opts
    false
