# 
# Make -- the OG build tool.
# Add any build tasks here and abstract complex build scripts into `lib` that can
# be run in a Makefile task like `coffee lib/build_script`.
# 
# Remember to set your text editor to use 4 size non-soft tabs.
# 

BIN = node_modules/.bin

# Start the server
s:
	$(BIN)/coffee app.coffee

# Start the server watching for file changes and restarting	
sw:
	$(BIN)/nodemon $(BIN)/coffee app.coffee

# Run all of the tests
test:
	make assets
	$(BIN)/mocha $(shell find test -name '*.coffee' -not -path 'test/helpers/*')
	$(BIN)/mocha $(shell find apps/*/test -name '*.coffee' -not -path 'test/helpers/*')

# Quickly compile assets to public/assets for development
assets:
	$(BIN)/stylus components/asset_package/all.styl -o public/assets
	$(BIN)/browserify components/asset_package/all.coffee -t coffeeify -t jadeify2 > public/assets/all.js

# Compiles assets for production (minifying, embeddeding, gzipping)
assets-production:
	make assets
	$(BIN)/sqwish public/assets/all.css -o public/assets/all.min.css
	$(BIN)/coffee lib/assets/embed_datauri.coffee public/assets/all.min.css
	$(BIN)/uglifyjs public/assets/all.js > public/assets/all.min.js
	gzip -f public/assets/all.min.js public/assets/all.min.css

# Uploads assets to S3
assets-to-cdn:
	$(BIN)/coffee lib/assets/to_cdn.coffee public/assets/all.min.css.gz public/assets/all.min.js.gz

# Runs all the necessary build tasks to push to staging or production
deploy:
	make assets-production
	APPLICATION_NAME=flare-$(env) make assets-to-cdn
	heroku config:add CDN_URL=//s3.amazonaws.com/flare-$(env)/assets/$(shell git rev-parse --short HEAD)/ --app=flare-$(env)
	git push git@heroku.com:flare-$(env).git master

deploy-staging:
	make deploy env=staging

deploy-production:
	make deploy env=production

.PHONY: test
