sinon = require 'sinon'
Inquiry = require '../../models/inquiry'
fabricate = require '../helpers/fabricate'

describe 'Inquiry', ->
  
  beforeEach ->
    @inquiry = new Inquiry fabricate 'artwork_inquiry_request'
  
  describe '#validate', ->
  
    it 'ensures a name and email for inquiries with a session', ->
      @inquiry.set session_id: 'foobar', name: null
      @inquiry.validate().should.include 'Please include a valid name'