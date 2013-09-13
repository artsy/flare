Backbone = require 'backbone'

module.exports = class FacebookShare extends Backbone.View

  events:
    "click" : "share"

  render: (params) ->
    @$el.attr
      href: "http://www.facebook.com/sharer.php?#{params}"

  share: ->
    width   = 548
    height  = 325
    toolbar = 0
    left    = ($(window).width()  - width) / 2
    top     = ($(window).height() - height) / 2
    opts    = "status=1,width=#{width},height=#{height},top=#{top},left=#{left}"
    window.open @$el.attr('href'), 'sharer', opts
    false
