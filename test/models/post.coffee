fabricate = require '../helpers/fabricate'
Post = require '../../models/post'

describe 'Post', ->
  
  beforeEach ->
    @post = new Post fabricate 'post'
  
  describe '#profile', ->
  
    it 'wraps the profile in a model', ->
      @post.set profile: fabricate('profile', title: 'foobar')
      @post.profile().get('title').should.equal 'foobar'
  
  describe '#artworks', ->
  
    it 'wraps the artworks in an artworks collection', ->
      @post.set artworks: [fabricate 'artwork', title: 'foobar']
      @post.artworks().first().get('title').should.equal 'foobar'
      
  describe '#images', ->
  
    it 'wraps the post_images in an image collection', ->
      @post.set post_images: [{ image_url: 'foobar' }]
      @post.images().first().get('image_url').should.equal 'foobar'
      
  describe '#fromNow', ->
    
    it 'returns the date in from now lingo', ->
      @post.set created_at: new Date(1999, 1, 1)
      @post.fromNow().should.include 'years ago'
      
  describe '#toFeaturedItem', ->
    
    it 'converts the post to a feature item', ->
      @post.set
        id: 'foo'
        title: 'bar'
        author: { name: 'baz' }
        shareable_image_url: 'qux'
      @post.toFeaturedItem().href.should.equal '/post/foo'
      @post.toFeaturedItem().title.should.equal 'bar'
      @post.toFeaturedItem().subtitle.should.equal 'baz'
      @post.toFeaturedItem().imageUrl.should.equal 'qux'
      
    it 'uses the first artworks image url if there is none', ->
      @post.set shareable_image_url: '', artworks: [fabricate('artwork')]
      @post.toFeaturedItem().imageUrl.length.should.be.above 1
      
  describe '#attachments', ->
    
    it 'returns an orderd array of hashes with models', ->
      @post.set attachments: [
        { type: 'PostArtwork', artwork: fabricate('artwork', medium: 'Cats on Canvas'), position: 2 }
        { type: 'PostLink', oembed_json: { foo: 'bar' }, position: 1 }
      ]
      @post.attachments()[0].type.should.equal 'PostLink'
      @post.attachments()[0].model.get('foo').should.equal 'bar'
      @post.attachments()[1].model.get('medium').should.equal 'Cats on Canvas'
      