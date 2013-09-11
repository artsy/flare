# 
# A function that helps create fixture data modeled after the Gravity API.
# Pass in the name of the model and any extending data and it'll return
# a vanilla javascript object populated with fixture json data.
# 
# e.g. `fabricate('artwork', { title: 'Three Wolf Moon'` })
# 
# TODO: Find a good way to share this between intertia/torque/microgravity
# 

_ = require 'underscore'

module.exports = fabricate = (type, extObj = {}) ->
  _.extend switch type

    # kept as an example
    when 'author'
      default_profile_id: "billpowers"
      id: _.uniqueId()
      name: "Bill Powers"
      type: "User"
    
  , extObj
