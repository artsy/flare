jade = require 'jade'
path = require 'path'
fs = require 'fs'
Shows = require '../../../collections/shows_feed'
fabricate = require '../../../test/helpers/fabricate'

describe 'Current shows template', ->
  
  render = (templateName) ->
    filename = path.resolve __dirname, "../templates/#{templateName}.jade"
    jade.compile(
      fs.readFileSync(filename),
      { filename: filename }
    )
  
  it 'shows a properly formatted fair booth', ->
    shows = new Shows [
      fabricate('show',
        name: 'Splattering of Foo paint'
        fair: fabricate('fair', name: 'Foobarzalooza 2013')
        fair_location: { display: 'Pier Bar, Booth Baz' }
        artworks: [fabricate('artwork')]
      )
    ]
    html = render('current_shows')(shows: shows.models, artworkColumnsTemplate: ->)
    html.should.include 'Foobarzalooza 2013'
    html.should.include 'Pier Bar, Booth Baz'
    html.should.not.include 'Splattering of Foo paint'
    
  it 'shows a properly formatted non-fair exhibition', ->
    shows = new Shows [
      fabricate('show',
        name: 'Splattering of Foo paint'
        fair: null
        artworks: [fabricate('artwork')]
      )
    ]
    html = render('current_shows')(shows: shows.models, artworkColumnsTemplate: ->)
    html.should.include 'Splattering of Foo paint'