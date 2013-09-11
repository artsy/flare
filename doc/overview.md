# Overview

This document will run through the basic concepts and workflow involved in writing features in microgravity.

## Tools to Familiarize with first

Before diving into the concepts unique to Microgravity it would be best to get familiarized with the established tools that Microgravity uses.

* [Node](http://nodejs.org/)
* [Backbone](http://backbonejs.org/)
* [Express](http://expressjs.com/)
* [Browserify](https://github.com/substack/node-browserify)
* [Coffeescript](http://coffeescript.org/)
* [Stylus](http://learnboost.github.io/stylus/docs/js.html)
* [Jade](http://jade-lang.com/)

## Terminology

### Project vs. Apps

Microgravity is built in a highly modular manner. Unlike Rails, and similar to Django, the entire repo represents a "project" instead of the Rails term "app". This distinction is made because "apps" are small express applications that are mounted into the main "project". Most apps will consist of a single page and any functionality within that page. However, if the need arises an app can become a more complex thick-client app with several pages and state.

Referring to "project-level" modules is referring to libraries or components that are used across apps and therefore are placed at the root project level. On the other hand an "app-level" module such as view in room might only exist inside the "artwork" app, and therefore placed inside apps/artwork.

An app will often drill back and require project-level dependencies, but project-level libraries or components shouldn't be requiring app-level dependencies. Apps also shouldn't need to reach into each other very often. The general idea is that an app folder should be able to be deleted and cause minimal effect on the rest of the project.

When in doubt put things at the app-level, and once you find yourself needing to re-use a portion of an app try to extract that code into a component or library.

### Components

Components are chunks of UI re-used across apps. These are similar to [bower](https://github.com/bower/bower) components, [component.js](https://github.com/component/component) components, or [jQuery UI](http://jqueryui.com/) components without the jQuery. Components can consist of any number of stylesheets, templates, and/or client-side code. They can range from something as complex as an autocomplete widget to something as simple as a headers stylesheet styling h1-h6 tags.

Microgravity doesn't have project-level templates and stylesheets to encourage modularizing these pieces into components. However for practicality's purpose if you need to write more global styles/templates/client-side-code, write it in /components/layout.

### Libraries vs. Models/Collections

Because Microgravity is built to share code client and server /lib serves as a place to put any javascript libraries. In some cases a library may only be useful in one environment, but in other cases, such as a date formatting library, it makes sense to write this in a common js format that can be required through npm or browserify.

Models and Collections wrap the Gravity API and store domain logic. These can work across apps, and client or server by swapping out Backbone.sync. In Rails you might write a model that does utility functionality such as image processing. However in Microgravity models are strictly for domain logic and data access/persistence via Gravity's API. Utility functionality should instead be written as a library module in /lib.

## Shared Data

Because Microgravity needs to share certain configuration and "global" data like the Gravity XAPP token there needs to be a place to store this. This is found in /lib/shared_data.coffee. This is simply a hash that get populated on the server with config vars, and exposed to the client through bootstrapping the data and injecting it via /components/layout/bootstrap.