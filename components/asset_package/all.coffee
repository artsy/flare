# 
# Simply includes each app's javascripts into one big package and
# requires the appropriate one based on location.pathname.
# In the beginning this will be easier for simplicity's sake, but as this
# package gets large, and we micro-optimize initial page load, we'll want
# to get more complex in how we break up and load assets.
# 

require '../../lib/zepto/index.coffee'

hash =
  
  '^/artwork/.*/contact_gallery': ->
    require('../../apps/artwork/client/submit_inquiry/bootstrap.coffee') true
  
  '^/artwork/.*/ask_specialist': ->
    require('../../apps/artwork/client/submit_inquiry/bootstrap.coffee') false
  
  '^/artwork/.*': ->
    require '../../apps/artwork/client/main_page.coffee'
  
  '^/search': ->
    require '../../apps/search/client.coffee'
  
  '^/artist/.*': ->
    require '../../apps/artist/client/index.coffee'
  
  '^/post/.*': ->
    require '../../apps/post/client.coffee'
    
  '^/feature/.*': ->
    require '../../apps/feature/client.coffee'
    
  '^/profile/.*': ->
    require '../../apps/profile/client.coffee'
  
  '^/show/.*': ->
    require('../../apps/show/client.coffee').init()
  
  '^/reset_password': ->
    require('../../apps/password/client.coffee').init()
  
  '^/.*/.*/browse/((artist|show)/.*)|shows': ->
    require('../../apps/fair/client/exhibitors.coffee').init()
  
  '^/.*/browse/filter/.*': ->
    require('../../apps/fair/client/artworks.coffee').init()
  
  '(^/.*/browse/exhibitors)|(^/.*/browse/artists)': ->
    require('../../apps/fair/client/main_page.coffee').init()
  
  '^/([^/]+)$': ->
    if BOOTSTRAP.FAIR?
      require('../../apps/fair/client/main_page.coffee').init()
    else if BOOTSTRAP.PROFILE?
      require '../../apps/profile/client.coffee'
    
  '^/$': ->
    require '../../apps/home/client/index.coffee'

# On DOM load iterate through the hash and load that app's JS
$ ->
  for regexStr, load of hash
    if location.pathname.match(new RegExp regexStr)
      load()
      break