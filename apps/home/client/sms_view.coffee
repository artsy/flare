_ = require 'underscore'
Backbone = require 'backbone'

module.exports = class SmsView extends Backbone.View

  ENTER: 13
  NUMPAD_ENTER: 108

  successText: "Great! Thanks for downloading Artsy."

  events:
    'click button' : 'submit'
    "keyup input"  : 'submitOnEnter'

  initialize: (options) ->
    @$input = @$('input')
    unless options.isTouchDevice
      _.delay @focusInput, 1000

  focusInput: =>
    @$input.focus()

  submit: ->
    @sending()
    phoneNumber = @$('input.phone_number').val()
    return false unless phoneNumber?.length > 0
    $.ajax
      type: "POST"
      url: "/send_link"
      dataType: "json"
      data:
        phone_number: phoneNumber
      success: (data, status, xhr) =>
        @$('input').addClass 'active'
        @$('.success').show().text @successText
        window?.analytics.track? "sent sms"
        @sent()
      error: (xhr, status, error) =>
        errorMessage = JSON.parse(xhr.responseText)?.message || status
        @$('.error').show().text errorMessage
        window?.analytics.track? "error sending sms: '#{errorMessage}'"
        @sent()

  submitOnEnter: (event) ->
    @submit() if _.include([@NUMPAD_ENTER, @ENTER], event.which)

  sending: ->
    @$('.error').hide().html ''
    @$('.success').hide().html ''
    @$el.addClass('sending')

  sent: ->
    @$el.removeClass('sending')
