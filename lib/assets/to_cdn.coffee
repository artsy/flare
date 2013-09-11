# 
# Pushes compiled assets to the proper S3 bucket to be served from cloudfront.
# 

path = require 'path'
knox = require 'knox'
{ S3_KEY, S3_SECRET, APPLICATION_NAME } = require '../../config'
{ exec } = require 'child_process'

client = knox.createClient
  key: S3_KEY
  secret: S3_SECRET
  bucket: APPLICATION_NAME
  
uploadFile = (filename) ->
  exec "git rev-parse --short HEAD", (err, commitHash) ->
    localPath = path.resolve process.cwd(), filename
    s3Path = path.resolve "/assets/#{commitHash.trim()}/", path.basename(filename)
    headers =
      'Content-Type': if filename.match /\.css/ then 'text/css' else 'application/javascript'
      'x-amz-acl': 'public-read'
      'Content-Encoding': 'gzip' if filename.match /gz$/
    client.putFile localPath, s3Path, headers, (err, res) ->
      if err
        console.warn err
        process.exit(1)
      else
        console.log "Uploaded #{filename} to #{s3Path}..."


# Run CLI if this module is run directly.
# 
# Takes file paths as arguments and uploads them to the /assets/ folder in 
# the APPLICATION_NAME config var.
# e.g. `coffee lib/assets/to_cdn.coffee public/assets/all.css public/assets/all.js

return unless module is require.main
files = process.argv[2..process.argv.length]
uploadFile(filename) for filename in files