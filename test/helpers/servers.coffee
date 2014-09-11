#
# Run a fake gravity server mounted to a test app (because of zombie.js lack of CORS).
# Useful for integration tests.
#

spawn = require('child_process').spawn
express = require 'express'

# Convenience to start the test app server on 5000.
@startServer = (callback) =>
  return callback() if @child?
  envVars =
    NODE_ENV: "test"
    APP_URL: 'http://localhost:5000'
    PORT: 5000
  envVars[k] = val for k, val of process.env when not envVars[k]?
  @child = spawn "make", ["s"],
    customFds: [0, 1, 2]
    stdio: ["ipc"]
    env: envVars
  @child.on "message", -> callback()
  @child.stdout.on "data", (data) -> console.log data.toString()

# Convenience to close the app server
@closeServer = =>
  @child?.kill()
  @child = null

process.on 'exit', @closeServer

# Start the servers if run directly
return unless module is require.main
@setup => @child.stdout.on 'data', (data) -> console.log(data.toString())
