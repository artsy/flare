Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
sd = require('sharify').data
analytics = require '../../lib/analytics.coffee'

module.exports = ->
  require 'jquery.poplockit'

setupAnalytics = ->
  # Initialize analytics & track page view if we included mixpanel
  # (not included in test environment).
  return if not mixpanel? or mixpanel is 'undefined'
  analytics(mixpanel: mixpanel, ga: ga)
  analytics.trackPageview()

setupAnalytics()
