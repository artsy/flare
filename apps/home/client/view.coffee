Backbone = require 'backbone'
_ = require 'underscore'
BrowseView = require './browse_view.coffee'
ExploreView = require './explore_view.coffee'
CollectView = require './collect_view.coffee'
SmsView = require './sms_view.coffee'
iPhoneView = require './iphone_view.coffee'

module.exports = class HomePageView extends Backbone.View
  
  el: 'body'

  headerTextMargin: 60
  headerWidth: 350 # todo - make responsive

  events:
    'click header a' : 'sectionNavClick'
    'click arrow'    : 'nextSectionClick'

  sections:
    "browse" : (-> new BrowseView(parent: @) )
    "explore" : (-> new ExploreView(parent: @) )
    "collect" : (-> new CollectView(parent: @) )

  initialize: ->
    @$headerItems = @$('.app-header a')
    @$window = $(window)
    @$arrow = @$('#arrow')
    @$header = @$('.app-header')
    @$largeHeaderText = @$('.hero .content')

    @smsForm = new SmsView(parent: @)
    @iphone = new iPhoneView(parent: @, el: @$('#iphone'))
    @iphone.on 'repositioned', (=> @sizeSections())
    @sizeSections()
    
    _.delay =>
      @show()
    , 400

    # @animateIphoneImages()

  show: ->
    @iphone.$el.addClass 'visible'
    @$header.addClass 'visible'
    @$largeHeaderText.addClass 'visible'

  sizeSections: ->
    height = @$window.height()
    @$('#content').css(
      'margin-top': "#{height}px"
      'margin-bottom': "#{height}px"
    ).find('section').css
      'min-height': "#{height}px"

    rightHeaderPosition = @iphone.left + @iphone.width + @headerTextMargin
    leftHeaderPosition = @iphone.left - @headerTextMargin - @headerWidth

    @$largeHeaderText.css
      left: rightHeaderPosition

    @$('#content section .right').css
      left: rightHeaderPosition
    @$('#content section .left').css
      left: leftHeaderPosition

  sectionNavClick: (event) =>
    section = $(event.target).attr 'data-section-name'
    @smoothTransitionSection section

  nextSectionClick: =>

  smoothTransitionSection: (section) ->

  showArrow: ->
    @$arrow.show()

  hightlightHeaderSection: ->
    @$headerItems.removeClass 'selected'
