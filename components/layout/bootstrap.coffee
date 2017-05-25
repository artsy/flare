Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'
sd = require('sharify').data
{SEGMENT_API_KEY} = require '../../config.coffee'

module.exports = ->
  require '../poplockit/jquery.poplockit.coffee'

setupAnalytics = ->
  # (not included in test environment).
  return if not analytics? or analytics is 'undefined'
  analytics.load(SEGMENT_API_KEY);
  analytics.page();

setupAnalytics()
