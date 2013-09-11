# 
# CSS3 columns can leave extra vertical space at the bottom.
# This Zepto plugin will remove that vertical space.
# 

_ = require 'underscore'

$.fn.removeColumnSpace = ->
  $(@).each (i, el) -> removeColumnSpaceFrom($ el)
    
removeColumnSpaceFrom = module.exports = ($container) ->
  setHeight = ->
    lowestEl = _.last _.sortBy $container.children(), (el) ->
      $(el).offset().top + $(el).height()
    height = ($(lowestEl).offset().top + $(lowestEl).height()) - $container.offset().top
    $container.height height
  # Waits for any child images to finish loading before calculating & setting the height
  # so that it doesn't pre-maturely cut off the columns
  $imgs = $container.find('img')
  setHeight = _.after $imgs.length, setHeight
  $imgs.on 'load', setHeight