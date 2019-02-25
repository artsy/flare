# Getting Started with Flare

*Flare* is the codename for the iphone splash page website iphone.artsy.net.

## Install Node.js

It is recommended to use the [nvm](https://github.com/creationix/nvm) tool to manage node versions and install node.

First install NVM. See [this page](https://github.com/creationix/nvm) for latest information.

````
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
````

Reopen a shell and install node.js.

````
nvm install 8.12
````

Then tell nvm to use the latest version of node by default and to update your PATH.

````
nvm alias default 8.12
````

## Install Node Modules

````
yarn install
````

## Run the Server

Run the server, and open flare at [localhost:3003](http://localhost:3003).

````
make s
````

## See It

Navigate to http://localhost:3003 with a browser to see the website.
