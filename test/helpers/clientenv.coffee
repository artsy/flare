# 
# Sets up an environment that mimics a browser by globally exposing pieces such as a DOM 
# with jsdom, and libraries like Zepto which refuse to adopt commonjs patterns b/c of their 
# bullheaded authors. This allows us speedily to test client-side components that need a 
# generic DOM environment like backbone views or vanilla Zepto spagetti.
#

jsdom = require 'jsdom'
jade = require 'jade'
fs = require 'fs'
path = require 'path'
rewire = require 'rewire'
Backbone = require 'backbone'
sinon = require 'sinon'

globals = {}

# Exposes globals and sets up the current process to act like a browser environment.
# 
# @param {Function} callback

@setup = (callback) ->
  Backbone.sync = Backbone._sync if Backbone._sync?
  if window?
    return callback(window)
  jsdom.env
    html: "<html><body></body></html>"
    done: (errs, window) ->
      attachGlobals window
      callback()

# Helper that combines commonly used client-side setup such as rewiring client-side
# templates, rendering a server-side template, etc. into one convenient options hash.
# 
# @param {Object} parentModule Pass in the parent module to allow relative paths
# @param {String} filename Filename to prepare
# @param {Object} options 
#   clientTemplates: Array of client-side template filename dependencies
#   serverTemplate: Hash of `filename` and `locals` for the dependent server-side template
#   done: Callback function calls back with (preparedModule)

@prepare = (clientFilename, parentModule, options) ->
  moduleDir = path.dirname(parentModule.filename)
  @setup =>
    @renderTemplate(
      path.resolve(moduleDir, options.serverTemplate.filename)
      options.serverTemplate.locals
    ) if options.serverTemplate
    preparedModule = rewire path.resolve(moduleDir, clientFilename)
    @rewireTemplates(preparedModule, options.clientTemplates) if options.clientTemplates
    options.done? preparedModule

# Deletes the globals exposed by setup

@teardown = =>
  delete global[key] for key, val of globals

# Helper for rendering a server-side template's into the fake browser's body.
# Will strip out all script tags first to avoid jsdom trying to run scripts.
# 
# @param {String} filename
# @param {Object} options Options passed into jade

@renderTemplate = (filename, options) ->
  $html = $ jade.compile(
    fs.readFileSync(filename),
    { filename: filename }
  ) options
  $html.find('script').remove()
  $('body').html $html.html()

# Helper for rewiring client-side templates that were meant for jadeify
# into something that can be tested serverside.
# 
# @param {Object} scope The object return from rewire .e.g `scope = rewire '../client'
# @param {Object} varNames An array of template variable names

@rewireTemplates = (scope, varNames) ->
  for varName in varNames
    dir = path.dirname scope.__get__('module').filename
    tmplFilename = scope.__get__(varName).toString().match(/require\('(.*).jade'\)/)[1] + '.jade'
    filename = path.resolve(dir, tmplFilename)
    scope.__set__ varName, jade.compile(
      fs.readFileSync(filename),
      { filename: filename }
    )

# Used in setup to expose any libraries or global variables expected on the client-side.
# 
# @param {Object} window The jsdom window object

attachGlobals = (window) =>
  global.window = globals.window = window
  global.navigator = globals.navigator = window.navigator
  global.document = globals.document = window.document
  global.BOOTSTRAP = globals.BOOTSTRAP = {}
  global.$ = globals.$ = global.jQuery = globals.jQuery = Backbone.$ = require '../../lib/jquery.js'
