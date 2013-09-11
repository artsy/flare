# 
# Embeds images, fonts, svgs and such using data-uri into a stylesheet.
# Code stolen from [nap](https://github.com/craigspaeth/nap).
# 
# TODO: Extract into it's own Open Source node module.
# 

path = require 'path'
fs = require 'fs'
_ = require 'underscore'
_.mixin require 'underscore.string'
fs = require 'fs'

module.exports = embed = (contents, publicDir) =>
  
  # Table of mime types depending on file extension
  mimes =
    '.gif' : 'image/gif'
    '.png' : 'image/png'
    '.jpg' : 'image/jpeg'
    '.jpeg': 'image/jpeg'
    '.svg' : 'image/svg+xml'
    '.ttf' : 'font/truetype;charset=utf-8'
    '.woff': 'font/woff;charset=utf-8'
  
  offset = 0
  offsetContents = contents.substring(offset, contents.length)
  
  return contents unless offsetContents.match(/url/g)?
  
  # While there are urls in the contents + offset replace it with base 64
  # If that url() doesn't point to an existing file then skip it by pointing the
  # offset ahead of it
  for i in [0..offsetContents.match(/url/g).length]

    start = offsetContents.indexOf('url(') + 4 + offset
    end = contents.substring(start, contents.length).indexOf(')') + start
    assetFilename = _(contents.substring start, end).chain().trim("'").trim('"').value()
    assetFilename = path.join publicDir, assetFilename
    mime = mimes[path.extname assetFilename]
    
    if mime?
      if fs.existsSync assetFilename
        base64Str = fs.readFileSync(assetFilename).toString('base64')
        newUrl = "data:#{mime};base64,#{base64Str}"
        contents = _.splice(contents, start, end - start, newUrl)
        end = start + newUrl.length + 4
      else
        throw new Error 'Tried to embed data-uri, but could not find file ' + assetFilename
    else
      end += 4
    
    offset = end
    offsetContents = contents.substring(offset, contents.length)
  
  contents
  
# Run CLI if this module is run directly.
# 
# Takes a css file as an argument and rewrites it with embedded assets.
# e.g. `coffee lib/assets/embed_datauri.coffee public/assets/all.css

return unless module is require.main
file = (path.resolve process.cwd(), process.argv[2])
fs.writeFileSync file, embed(fs.readFileSync(file).toString(), process.cwd() + '/public')