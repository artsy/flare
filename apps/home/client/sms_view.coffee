Backbone = require 'backbone'
_ = require 'underscore'

module.exports = class SmsView extends Backbone.View

  ENTER: 13
  NUMPAD_ENTER: 108

  events:
    'click button' : 'submit'
    "keyup input"  : 'submitOnEnter'

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
        @$('.success').show().text JSON.parse(xhr.responseText)?.message
        @sent()
      error: (xhr, status, error) =>
        @$('.error').show().text JSON.parse(xhr.responseText)?.message || status
        @sent()

  submitOnEnter: (event) ->
    @submit() if _.include([@NUMPAD_ENTER, @ENTER], event.which)

  sending: ->
    @$('.error').hide().html ''
    @$('.success').hide().html ''
    @$el.addClass('sending')

  sent: ->
    @$el.removeClass('sending')
