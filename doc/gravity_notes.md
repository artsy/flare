# Gravity Notes

This document will outline helpful notes and common issues when using Gravity with Microgravity, such as API pitfalls or how to find certain kinds of data in Gravity.

## Finding Unique Data Models

Below are some commands you can run in your Gravity Rails console to find a specific kind of data. 
e.g an artwork with a tall image or featured post, a partner with no shows, etc.

### Artwork with a featured post

````ruby
Artwork.find(PostArtworkFeature.first.artwork_id).slug
````

### Featured links on the home page

First get a featured set by a unique key.

GET /api/v1/sets?key=homepage:features

Then use the id from the response to fetch the sets, e.g.

````
{
  "owner": null,
  "id": "5172bbb97695afc60a000001",
  "published": true,
  "key": "homepage:features",
  "name": "Featured section on the homepage.",
  "description": "",
  "item_type": "FeaturedLink",
  "owner_type": null
}
````

GET /api/v1/set/5172bbb97695afc60a000001/items?size=4

### Related artists to an artist

First fetch the related layers.

GET /api/v1/related/layers?artist=andy-warol

Then use the response to fetch the artists, e.g.

````
[
  {
    id: 'main',
    name: 'Related Artists'
  },
  {
    id: 'contemporary',
    name: 'Related Contemporary'
  }
]
````

GET /api/v1/related/layer/main/artists?artist[]=andy-warhol
GET /api/v1/related/layer/contemporary/artist[]=artist=andy-warhol

## Homepage Features

First fetch the feature.

http://artsy.net/api/v1/feature/:id 

Then fetch the sets in the feature

http://artsy.net/api/v1/sets?owner_type=Feature&owner_id=#{:id}

and get back some json like:

````
[
  {
    "owner": {},
    "id": "51a8ef2dd470b6369b000002",
    "item_type": "Sale"
  }
]
````

With this you fetch the items in those sets

http://artsy.net/api/v1/set/51a8ef2dd470b6369b000002/items

and get back some json like:

````
[
  {
    "id": "whitney-art-party",
    "name": "Whitney Art Party"
  }
]
````

Which depending on the "item_type" from the previous API should help you determine how to proceed. In this case it's a sale so we want to fetch the artworks:

http://artsy.net/api/v1/sale/whitney-art-party/sale_artworks

## API conventions

### Pagination

Pagination usually is done with a `page` and `size` query param. E.g. `/api/v1/artworks?page=2&size=10`. However sometimes an API will return array results as a hash 

e.g.

````
{
  results: [],
  next: '123abc'
}
````

In this case the next page can be fetched by passing the `next` value as the `cursor` query param e.g. `/api/v1/profile/craig/posts?size=10&cursor=123abc`


## Making an Order ("Buy" button)

### Logged out user

First add a pending order.

POST /api/v1/me/order/pending/items

With body data
````
{
  artwork_id: '', // The artwork to be purchased
  edition_set_id: '', // The edition to be purchased if applicable
  session_id: '' // Pass in your own session id, in our case express's req.session.id
}
```
With the returned order json, redirect to the secure checkout flow.

https://secure.artsy.net/order/#{order.id}/resume?token={order.token}