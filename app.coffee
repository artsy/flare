#
# Main app file that runs setup code and starts the server process.
# This code should be kept to a minimum. Any setup code that gets large should be
# abstracted into modules under /lib.
#

# Add NodeFly monitoring at the very beginning
{ STRONGLOOP_KEY, APPLICATION_NAME, NODE_ENV, PORT } = require './config'
require('strong-agent').profile(
  STRONGLOOP_KEY,
  [APPLICATION_NAME, 'Heroku']
) unless NODE_ENV in ['development', 'test']

# Setup the project app
express = require 'express'
setup = require './lib/setup_project'

module.exports = app = express()
setup app

# Start the server if the app has been run directly
return unless module is require.main
app.listen PORT, ->
  console.log "Flare listening on port " + PORT
  process.send? 'listening'
