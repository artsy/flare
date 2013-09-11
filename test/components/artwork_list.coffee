Artworks = require '../../collections/artworks'
fabricate = require '../helpers/fabricate'
path = require 'path'
fs = require 'fs'
jade = require 'jade'

render = (locals) ->
  filename = path.resolve __dirname, '../../components/artwork_list/template.jade'
  jade.compile(
    fs.readFileSync(filename),
    { filename: filename }
  ) locals


describe 'artwork_list component', ->
  
  it 'renders markdown from sales', ->
    artworks = new Artworks fabricate 'artwork', 'saleInfo.user_notes': '**Lovely!**'
    render(artworks: artworks.models).should.include '<strong>Lovely!</strong>'