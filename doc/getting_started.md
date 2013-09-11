# Getting Started with Microgravity

*Microgravity* is the codename for the mobile website m.artsy.net.

Before you can set up Microgravity for development you will need to set up [Gravity](https://github.com/artsy/gravity) which will provide the Artsy API Microgravity consumes. This doc will assume you've set up XCode and common development tools such after getting started with Gravity.

## Install Node.js

It is recommended to use the [nvm](https://github.com/creationix/nvm) tool to manage node versions and install node.

First install NVM

````
curl https://raw.github.com/creationix/nvm/master/install.sh | sh
````

Then install the latest node

````
nvm install 0.10
````

Then tell nvm to use the latest version of node by default and to update your PATH

````
nvm alias default 0.10
````

## Install Node Modules

````
npm install
````

Although not necessary, it's recommended to install mocha and coffeescript globally for debugging.

````
npm install mocha -g
npm install coffee-script -g
````

## Run the Server

Make sure Gravity is running on localhost:3000, then run the server, and open microgravity at [localhost:3003](http://localhost:3003).

````
make s
````

If you would like to watch for changes and restart the server to reload code using [nodemon](https://github.com/remy/nodemon).

````
make sw
````