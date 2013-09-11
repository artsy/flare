# Coding Style Guide

This document will lay out coding style conventions for microgravity. Please try to follow these to your best but don't take it as dogma.

## Casing

* underscore_case for files and folders
* camelCase for all coffeescript variables
* ClassCase for all coffeescript classes (javascript prototype functions) such as Backbone models
* dashed-case for all CSS classes and Stylus mixins or variables
* CONSTANT_CASE and constants (if you're doing this often you might want to consider how to refactor away from using globals)

## Line length

Try to keep lines under 100 characters. This isn't a hard rule though, if you find it clearer to express beyond 100 characters feel free to do so. Just please don't get carried away with 200 character clever one liners.

## Coffeescript style guide

Generally follow the style guide laid out by [Github](https://github.com/styleguide/javascript). Points such as under the "GitHub" namespace and use $.ajax won't apply because we use browserify and a client/server shared http library to obviate these points.

## Modules

Because of browserify when writing code that can work on the client it's best to keep to standard node module syntax. This means using `module.exports =` over `this =` or `@property =` as well as including the `.coffee` file extensions in your requires. E.g. `sync = require '../lib/backbone_server_sync.coffee`.

## Comments/Documentation

For anything complex that deviates out of common patterns such as a special purpose library please write a document in the /doc folder. If it's just a method/function that's unconventional please write a block of comments above it preferably describing the arguments, returns, and arguments passed to callbacks. For anything that fits in the typical workflow of the app feel free to leave out comments or documentation.

As a rule of thumb, when in doubt write comments or documentation. More documentation is almost always better than less. It might be worth looking into [docco]() for some use cases as well.