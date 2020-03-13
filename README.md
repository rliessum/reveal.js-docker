reveal.js-docker
===

[![Build Status](https://oss.cloudogu.com/jenkins/buildStatus/icon?job=cloudogu-github%2Freveal.js-docker%2Fmaster)](https://oss.cloudogu.com/jenkins/job/cloudogu-github/job/reveal.js-docker/job/master/)
[![](https://img.shields.io/microbadger/layers/cloudogu/reveal.js)](https://hub.docker.com/r/cloudogu/reveal.js)
[![](https://img.shields.io/docker/image-size/cloudogu/reveal.js)](https://hub.docker.com/r/cloudogu/reveal.js)

Docker images providing easier to use, opinionated reveal.js web apps - web-based slides/presentations.

Evolution of [cloudogu/reveal.js-docker](https://github.com/cloudogu/reveal.js-docker).
Allows for 
* less cluttered Repos (more slides, less reveal.js)
* faster startup / builds (don't have to build reveal.js over and over again)
* easier updates (new version of docker image; no git merge necessary)

# Table of contents
<!-- Update with `doctoc --notitle README.md`. See https://github.com/thlorenz/doctoc -->
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [How to use](#how-to-use)
  - [Simplest start](#simplest-start)
  - [Ship your own slides](#ship-your-own-slides)
  - [Index.html pseudo-template](#indexhtml-pseudo-template)
  - [Examples](#examples)
- [Development](#development)
  - [Tests](#tests)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# How to use

## Simplest start 

Ships a default presentation:

```bash
docker run --rm -p 8080:8080 cloudogu/reveal.js
```

## Ship your own slides

See also [real-life examples](#examples) and [index.html pseudo-template](#indexhtml-pseudo-template)

* Mount markdown slides to `/docs/slides`
* Optionally mount additional folders to web server, e.g. like so:  
 `-v  $(pwd)/images:/reveal/images`
* Mount folder containing HTML fragment files ([examples](scripts/test/)) to `/resources`
  * `slides.html` -> Pick the slides from `docs/slides` ([example](scripts/test/slides.html))
  * `additional.js` - script executed before initializing reveal.js
  * `body-end.html` - `html` injected at the end of HTML `<body>`
  * `footer.html` - rendered at the footer (lower left corner) for now only works with cloudogu Themes
* Optional Env vars: 
  * `TITLE`
  * `THEME_CSS`
     * `css/cloudogu.css`
     * `css/cloudogu-black.css`
  * `SHOW_NOTES_FOR_PRINTING` - print speaker notes - defaults to `false`.
  * `ADDITIONAL_REVEAL_OPTIONS` - [additional reveal.js options](https://github.com/hakimel/reveal.js/#configuration)
  * `ADDITIONAL_DEPENDENCIES` - additional reveal.js dependencies, e.g. plugins  
     e.g. `-e ADDITIONAL_DEPENDENCIES="{ src: 'plugin/tagcloud/tagcloud.js', async: true }" `  
     Note that these files have to be mounted to the /reveal folder, e.g. here `-v $(pwd)/plugin/tagcloud:/reveal/plugin/tagcloud`
* Start Container

```bash
# Development mode (with live reloading)
docker run --rm \
    -v $(pwd)/docs/slides:/reveal/docs/slides \
    -v $(pwd)/scripts/test:/resources \
    -e TITLE='my Title' -e THEME_CSS='css/cloudogu-black.css' \
    -p 8000:8000 -p 35729:35729 \
    cloudogu/reveal.js:dev

# Production Mode (smaller, more secure, just a static HTML site served by NGINX)
docker run --rm \
    -v $(pwd)/docs/slides:/reveal/docs/slides \
    -v $(pwd)/scripts/test:/resources \
    -e TITLE='my Title' -e THEME_CSS='css/cloudogu-black.css' \
    -p 8080:8080 \
    cloudogu/reveal.js
```

## Index.html pseudo-template

An overview where the env vars and HTML Fragment are injected:

```html
<!doctype html>
<html>
<head>
    <title>${TITLE}</title>
    
    <link rel="stylesheet" href="${THEME_CSS-css/cloudogu.css}">
</head>
<body>
    <div class="reveal">
        <!-- optional: footer.html -->
        <div class="slides">
        <!-- slides.html-->
        </div>
    </div>
    const showNotesForPrinting = ${SHOW_NOTES_FOR_PRINTING};
    <!-- Optional: <script>additional.js</script>-  -->
    <script>
    // ... Initializes reveal.js
        dependencies: [
                         // ...,
                         ${ADDITIONAL_DEPENDENCIES}
                       ]
        ${ADDITIONAL_REVEAL_OPTIONS}
    </script>
    
    <!-- optional: body-end.html -->
</body>
</html>
```

## Examples

* [cloudogu/k8s-security-3-things](https://github.com/cloudogu/k8s-security-3-things)

# Development

Build Docker Images, from repo root

```bash
docker build -t prod .
docker build -t dev --build-arg ENV=dev .
```

Note: If only one build is required, buildkit would be more efficient. However, prod is failing with buildkit.
Try it with `export DOCKER_BUILDKIT` See [this issue](https://github.com/moby/moby/issues/735=

## Tests

Run tests locally

```bash
# For now manually
cd scripts/test
../src/templateIndexHtml
```
