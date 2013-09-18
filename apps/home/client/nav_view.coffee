Backbone = require 'backbone'
_ = require 'underscore'

module.exports = class NavView extends Backbone.View

  PAGE_UP_KEY: 33
  PAGE_DOWN_KEY: 34

  scrollSpeed: 300

  sectionSelectors: ['.hero', 'section:eq(0)', 'section:eq(1)', 'section:eq(2)', '.bottom-anchor']

  events:
    'click header .links a' : 'sectionNavClick'
    'click .hero .arrow'    : 'nextSectionClick'
    
  initialize: ->
    @bindPageUpDownEvents()
  
  sectionNavClick: (event) =>
    event.preventDefault()
    section = $(event.target).attr 'data-section-name'
    @smoothTransitionSection section
    window?.mixpanel?.track? "click header item '#{section}'"
    false

  smoothTransitionSection: (section) ->
    $section = $("##{section}")
    $('html, body').animate(scrollTop: $section.offset().top, @scrollSpeed)

  nextSectionClick: =>
    window?.mixpanel?.track? "clicked down arrow"
    @smoothTransitionSection 'explore'
    return false

  currentSectionForScrollTop: (scrollTop) ->
    sectionHeight = @options.parent.getHeight()
    Math.floor scrollTop / sectionHeight

  scrollNextSectionForScrollTop: (scrollTop) ->
    currentSection = @currentSectionForScrollTop scrollTop
    scrollTop = $(@sectionSelectors[currentSection + 1]).offset()?.top
    scrollTop = if scrollTop then scrollTop else $(document).height()
    $('html, body').animate(scrollTop: scrollTop, @scrollSpeed)

  bindPageUpDownEvents: ->
    $(window).on 'keyup', _.throttle(((event) => @onKeyUp(event)), 70)

  onKeyUp: (event) ->
    key = event.which
    if key == @PAGE_DOWN_KEY
      @scrollNextSectionForScrollTop $(window).scrollTop()
      event.preventDefault()

  delayShowArrow: ->
    bottom = (@options.iphone.top / 2) - 10
    _.delay =>
      @options.$arrow.css
        bottom: bottom
        left: @options.iphone.left
        width: @options.iphone.width
      @options.$arrow.addClass 'active'
    , 1000
