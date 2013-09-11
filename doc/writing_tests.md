# Writing Tests

Microgravity uses a couple different tools and patterns for tests. This document will explain how to use these and outline best practices.

## Project-level vs. App-level tests

Because Microgravity modularizes features into individual express apps, it makes sense to separate what tests are meant to be app-level and what are project-level (see [the overview doc](https://github.com/artsy/microgravity/blob/master/doc/overview.md) for more explanation of project vs apps). App level tests should live inside /test in the individual app, e.g. apps/artwork/test. These should test any files inside that app, and shouldn't crawl backwards to test other modules (although crawling back to include dependencies is fine). Project level tests live under /test and are used to test project-level modules such as /components and /lib.

## 3rd Party Tools

Microgravity uses the following tools for testing:

* [Mocha](http://visionmedia.github.io/mocha/) with [should.js](https://github.com/visionmedia/should.js/) - BDD testing DSL.
* [Zombie](http://zombie.labnotes.org/) - Headless integration testing library.
* [Sinon](http://sinonjs.org/) Spy/stubbing library.
* [rewire](https://github.com/jhnns/rewire) Dependency injection tool.

## Running Tests

To run all tests in parallel simply execute the make command.

````
make test
````

In development you might not want to wait for the entire suite to finish so it's much more practical to use mocha as a stand alone.

Make sure mocha is installed globally

````
npm install mocha -g
````

and test an individual file

````
mocha test/models/artwork.coffee
````

## Helpers

There are a couple test helpers that are written to help test things unique to the Artsy stack. These can be found under test/helpers. Most likely helpers will live under ./test/helpers but if a single app gets big enough in complexity to justify writing a helper that will only be used in that app, then please place that under that app's test folder.

### clientenv.coffee

Creates a fake client-side environment in node.js mainly using jsdom so that one can test client-side code as if node were a browser. The `setup` method should globally expose any browser APIs necessary to get started testing client-side code, and the `teardown` method should delete all of those globals so regular server-side code can resume.

### fabricate.coffee

Simply a function used to create fixture data for Gravity API json responses.

### servers.coffee

Creates an express server that act's like Gravity for integration tests and mounts that to the project server to be run in "test" mode. 