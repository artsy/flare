# File Structure Conventions

This document will outline the file structure and lay out conventions for where files should go.

For starters an important concept to take into consideration is the root level folder is considered the "project" and inside ./apps are "apps" (a similar organization to [Django](https://www.djangoproject.com/)). This helps distinguish where project-wide vs. app-specific components should be placed.

Now that we know that, the general file structure is laid out as such:

````
apps
  /artwork
    index.coffee
    /stylesheets
    /templates
    /client
      index.coffee
      /views
  /artist
  /home
models
  artwork.coffee
collections
  artworks.offee
lib
  /backbone_server_sync
components
  /header
    header.jade
    index.styl
    index.coffee
  /artwork_columns
doc
  getting_started.md
public
  /images
  favicon.ico
test
config
  public.coffee
  private.coffee
  index.coffee
  
app.coffee
Makefile
package.json
README.md
````

## apps

A place to store "sub-apps". These will generally be a single page such as the artwork or artist page. If the need arises to manage complex client-side state this could be a Backbone app that manages multiple pages or a complex widget such as view in room. However in general, if it involves a page refresh it's probably it's own app.

### File structure in apps

The simplest app will likely involve just an `index.coffee` (The express app to mount), a template.jade, and maybe a stylesheet.styl. A more complex app might involve templates, stylesheets, client-side javascript, Backbone views/routers, etc. And example might look like so:

````
apps
  /favorites
    /client
      /views
        /artworks
          list_item.coffee
      /routers
        index.coffee
      index.coffee
      /lib
        /vendor
          uikit.js
    /stylesheets
      detail.styl
      realted.styl
    /templates
      /client
        list_item_popover.jade
      /server
        main_page.jade
      /shared
        list_item_.jade
````

You are free to structure you components as seen fit, but please take this example as a guide for organizing a larger app.

## models

Backbone domain models shared client and server. Use [superagent](https://github.com/visionmedia/superagent) to make server-side or client-side http requests to the Gravity API. Any client or server specific logic that you are tempted to put into the model, try to find a way extract it into a library or extend the model inside the individual app that uses it.

## collections

Write any Backbone collections here.

## lib (.coffee files)

A place to store all project level libraries. An example includes `backbone_server_sync` which is used to overwrite Backbone's sync to work server-side and client-side. 

## components (modules containing .jade, .styl, and/or .coffee files)

A place to store shared UI components that may be used across apps such as a header, modal, or artwork columns. These could be full-fledged UI widgets that involve stylesheets, templates, and client-side code similar to a jQuery UI plugin, or as simple as a stylesheet or template that is responsible for a chunk of UI.

Try to think of components in ways that can be modularized to have a distinct responsibility. For instance a widget like "autcomplete" or "modal" could involve css/js/and templates but even a component as simple as "headers" could just involve a stylesheet of h1-h6 classes. If you do your best and just can't think of a way to chunk off your UI and need something more "global" then feel free to add to components/layout.

## doc

Markdown documentation of all sorts.

## public

A place to store and server static assets like images, fonts, etc.

## test

Tests for project-wide code such as components, libraries, models, etc. Individual apps should have their own test directory that can be run alone and included in the larger suite when needed.

## config

Contains the configuration variables. There should be almost no code here, it's simply a place to describe env variable names and provide sensible defaults for dev. Because configuration variables
could be shared client and server there's a need to define which are public and can be exposed to the client-side in `config/public.coffee` and which are private and shouldn't be visible to users.

## app.coffee

The actual app server code that includes the individual apps, runs any setup code, and starts the main server process. Code should be minimal here and extracted into libs if setup gets complex.

## Makefile

An OG simple build tool blessed by much of the node.js community. Like `rake` for Rails any build commands can be bundled here such as `make assets`. If a build task gets complex and requires logic, then wrap up the complexity into a script in /lib, write tests for it, and add a `coffee lib/generate_emails` under a Makefile alias. No more treating build task logic as second class citizens.

## package.json

Node.js version of Gemfile, describes dependencies and other configuration.

## README.md

Speaks for itself.