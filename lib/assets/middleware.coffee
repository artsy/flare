# 
# Middleware used to compile assets on request for development.
# 

{ exec } = require 'child_process'

module.exports = (req, res, next) =>
  return next() if @compiling
  console.log 'compiling assets...'
  @compiling = true
  exec 'make assets', (err, stdout, stderr) => 
    @compiling = false
    if err
      next err
    else
      next()