# Deploying to Heroku

Flare is deployed to Heroku's [flare-staging](https://dashboard.heroku.com/apps/flare-staging) and [flare-production](https://dashboard.heroku.com/apps/flare-production) applications.

The Heroku application(s) need to be configured with `NODE_ENV` set to *staging* or *production*, as follows (using *staging* as an example).

```
$ heroku config:add NODE_ENV=staging --app=flare-staging
```

## DNS

[DynECT](http://manage.dynect.com) points [apple.artsy.net](http://apple.artsy.net) and [apple.staging.artsy.net](http://apple.staging.artsy.net) to Flare.

## Deployment Tasks

Deployment tasks are set-up as [deploy-flare-staging](http://joe.artsy.net:9000/job/deploy-flare-staging) and [deploy-flare-production](http://joe.artsy.net:9000/job/deploy-flare-production) on Jenkins.

```
gem install heroku
npm install
make deploy-staging
```

## S3 Buckets and CloudFront

Assets are deployed to S3 to *flare-staging* and *flare-production* buckets and accessed by setting `CDN_URL` during deploy. The URLs of the CloudFront distributions are located in [Makefile](../Makefile) as well.
