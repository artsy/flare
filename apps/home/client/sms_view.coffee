Backbone = require 'backbone'

module.exports = class SmsView extends Backbone.View

  events:
    'click button' : 'submit'

  submit: ->
