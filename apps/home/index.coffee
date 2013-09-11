# 
# The home page
# 

express = require 'express'
routes = require './routes'

app = module.exports = express()
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'
app.get '/', routes.index
app.get '/home/featured_works', routes.featuredArtworks
app.get '/home/featured_posts', routes.featuredPosts