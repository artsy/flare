# 
# Run a fake gravity server mounted to a test app (because of zombie.js lack of CORS). 
# Useful for integration tests.
#
# TODO - remove this as we don't use gravity in this repo?

_ = require 'underscore'
express = require 'express'
fabricate = require './fabricate'
Backbone = require 'backbone'
{ spawn } = require 'child_process'
path = require 'path'

# Convenience to start the test app server on 5000.
@setup = (callback = ->) =>
  Backbone.sync = Backbone._sync if Backbone._sync?
  return callback() if @child?
  @child = spawn 'make', ['s'],
    customFds: [0, 1, 2]
    stdio: ['ipc']
    env: _.extend process.env,
      NODE_ENV: 'test'
      PORT: 5000
  @child.on 'message', callback

# Convenience to close the app server
@teardown = =>
  @child.kill()
  @child = null

process.on 'exit', => @child?.kill()

# Start the servers if run directly
return unless module is require.main
@setup => @child.stdout.on 'data', (data) -> console.log(data.toString())
