#Cloud Foundry Caching Route Service

Blatant plagiarism of the Cloud Foundry Staticfile Buildpack for nefarious caching purposes.

### How to use as a caching route service on PCF Dev

```
git submodule update --init
BUNDLE_GEMFILE=cf.Gemfile bundle
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager --uncached
cf create-buildpack caching-buildpack ./caching_buildpack-v1.0.0.zip 1 --enable
cd staticfile-app
cf push caching-app
cf create-user-provided-service caching-service -r https://caching-app.local.pcfdev.io
cd ../sinatra-test-app
cf push hello-sinatra
cf bind-route-service local.pcfdev.io caching-service --hostname hello-sinatra
```

The test app is configured to issue cacheable requests; repeated requests to http://hello-sinatra.local.pcfdev.io/ should show a cache hit:

```
$ curl -I http://hello-sinatra.local.pcfdev.io/
HTTP/1.1 200 OK
Cache-Control: public, max-age=10
Content-Length: 25
Content-Type: text/html;charset=utf-8
Date: Sat, 25 Jun 2016 15:40:11 GMT
Server: nginx
X-Cache-Status: HIT
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Vcap-Request-Id: 4c2178f5-4b23-4612-6827-1381ac572bb4
X-Vcap-Request-Id: f42899b6-0356-4ef4-410d-d9df6e6701cb
X-Vcap-Request-Id: cce5b6db-f151-483d-4143-0b2d874b119d
X-Xss-Protection: 1; mode=block
```

##Upstream Staticfile Buildpack docs below...

[![CF Slack](https://s3.amazonaws.com/buildpacks-assets/buildpacks-slack.svg)](http://slack.cloudfoundry.org)

A Cloud Foundry [buildpack](http://docs.cloudfoundry.org/buildpacks/) for static stites (HTML/JS/CSS).

### Buildpack User Documentation

Official buildpack documentation can be found at http://docs.cloudfoundry.org/buildpacks/staticfile/index.html.

### Building the Buildpack

1. Make sure you have fetched submodules

  ```bash
  git submodule update --init
  ```

1. Get latest buildpack dependencies

  ```shell
  BUNDLE_GEMFILE=cf.Gemfile bundle
  ```

1. Build the buildpack

  ```shell
  BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager [ --cached | --uncached ]
  ```

1. Use in Cloud Foundry

  Upload the buildpack to your Cloud Foundry and optionally specify it by name

  ```bash
  cf create-buildpack custom_node_buildpack node_buildpack-offline-custom.zip 1
  cf push my_app -b custom_node_buildpack
  ```

### Testing
Buildpacks use the [Machete](https://github.com/cloudfoundry/machete) framework for running integration tests.

To test a buildpack, run the following command from the buildpack's directory:

```
BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-build
```

More options can be found on Machete's [Github page.](https://github.com/cloudfoundry/machete)

### Contributing

Find our guidelines [here](./CONTRIBUTING.md).

### Help and Support

Join the #buildpacks channel in our [Slack community] (http://slack.cloudfoundry.org/) if you need any further assistance.

### Reporting Issues

Open a GitHub issue on this project [here](https://github.com/cloudfoundry/staticfile/issues/new)

### Active Development

The project backlog is on [Pivotal Tracker](https://www.pivotaltracker.com/projects/1042066)

### Acknowledgements

This buildpack is based heavily upon Jordon Bedwell's Heroku buildpack and the modifications by David Laing for Cloud Foundry [nginx-buildpack](https://github.com/cloudfoundry-community/nginx-buildpack). It has been tuned for usability (configurable with `Staticfile`) and to be included as a default buildpack (detects `Staticfile` rather than the presence of an `index.html`). Thanks for the buildpack Jordon!
