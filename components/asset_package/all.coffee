# 
# Simply includes each app's javascripts into one big package and
# requires the appropriate one based on location.pathname.
# In the beginning this will be easier for simplicity's sake, but as this
# package gets large, and we micro-optimize initial page load, we'll want
# to get more complex in how we break up and load assets.
# 

require '../../lib/jquery.js'

hash =
  
  '^/$': ->
    require '../../apps/home/client/index.coffee'

# On DOM load iterate through the hash and load that app's JS
$ ->
  for regexStr, load of hash
    if location.pathname.match(new RegExp regexStr)
      load()
      break
