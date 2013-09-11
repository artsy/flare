HeroUnits = require '../../collections/hero_units'
Artworks = require '../../collections/artworks'
Posts = require '../../collections/posts'

module.exports.index = (req, res, next) ->
  heroUnits = new HeroUnits
  heroUnits.fetch success: ->
    res.render 'page', heroUnits: heroUnits.models
    
module.exports.featuredArtworks = (req, res, next) ->
  Artworks.fetchSetItemsByKey 'homepage:featured-artworks',
    success: (artworks) ->
      res.render 'featured_works', artworks: artworks.models
    errors: (c, e) -> next e
    
module.exports.featuredPosts = (req, res, next) ->
  Posts.fetchSetItemsByKey 'homepage:featured-posts',
    success: (posts) ->
      res.render 'featured_posts', items: posts.models
    errors: (c, e) -> next e