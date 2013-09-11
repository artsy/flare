Backbone = require 'backbone'
fabricate = require '../helpers/fabricate'
Partners = require '../../collections/partners'

describe 'Posts', ->
  
  beforeEach ->
    @partners = new Partners [fabricate 'post']