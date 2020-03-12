FROM node:11.15.0-alpine as node

FROM node as aggregator 

RUN mkdir -p /dist/scripts
COPY . /dist/reveal

# Speed up build by removing dependencies that are large and not needed for this use case
# qunit -> pupeteer -> chrome
WORKDIR /dist/reveal/
RUN sed -i '/^.*grunt-contrib-qunit.*$/d ; /^.*express.*$/d' package.json 
RUN npm install
# Build minified js, css, copy plugins, etc.
RUN node_modules/grunt/bin/grunt --skipTests

COPY dockerfiles/scripts/src/* /dist/scripts/

FROM node
RUN apk add gettext # For envsubst
COPY --from=aggregator /dist /
EXPOSE 8000
EXPOSE 35729
ENTRYPOINT [ "/scripts/entrypoint.sh", "npm", "run", "start", "--prefix", "/reveal/"]