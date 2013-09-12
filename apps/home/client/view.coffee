Backbone = require 'backbone'
BrowseView = require './browse_view.coffee'
ExploreView = require './explore_view.coffee'
CollectView = require './collect_view.coffee'
SmsView = require './sms_view.coffee'
iPhoneView = require './iphone_view.coffee'

module.exports = class HomePageView extends Backbone.View
  
  el: 'body'

  headerTextMargin: 60

  events:
    'click header a' : 'sectionNavClick'
    'click arrow'    : 'nextSectionClick'

  sections:
    "browse" : (-> new BrowseView(parent: @) )
    "explore" : (-> new ExploreView(parent: @) )
    "collect" : (-> new CollectView(parent: @) )

  initialize: ->
    @$headerItems = @$('header a')
    @$window = $(window)
    @$arrow = @$('#arrow')
    @$header = @$('header')
    @$largeHeaderText = @$('.large-header .content')

    @smsForm = new SmsView(parent: @)
    @iphone = new iPhoneView(parent: @, el: @$('#iphone'))
    @iphone.on 'repositioned', (=> @sizeSections())
    @sizeSections()
    
    @show()
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

    @$largeHeaderText.css
      left: @iphone.left + @iphone.width + @headerTextMargin


  sectionNavClick: (event) =>
    section = $(event.target).attr 'data-section-name'
    @smoothTransitionSection section

  nextSectionClick: =>

  smoothTransitionSection: (section) ->

  showArrow: ->
    @$arrow.show()

  hightlightHeaderSection: ->
    @$headerItems.removeClass 'selected'
