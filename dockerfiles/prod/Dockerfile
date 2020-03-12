FROM node:11.15.0-alpine as node
FROM nginxinc/nginx-unprivileged:1.17.9-alpine as nginx

FROM node as aggregator 

RUN mkdir -p /tmp/reveal /dist/scripts
COPY . /tmp/reveal

# Speed up build by removing dependencies that are large and not needed for this use case
# qunit -> pupeteer -> chrome
WORKDIR /tmp/reveal
RUN sed -i '/^.*grunt-contrib-qunit.*$/d ; /^.*express.*$/d' package.json 
RUN npm install

COPY dockerfiles/scripts/src/* /dist/scripts/
COPY dockerfiles/prod/entrypoint.sh /dist/scripts

# Install envsubst to be used for index.html templating in final image
RUN apk add gettext # For envsubst -> if libaries are missing, find out with: ldd $(which envsubst)
RUN mkdir -p /dist/usr/bin/
RUN cp /usr/bin/envsubst /dist/usr/bin

# Package only whats necessary for static website 
RUN mkdir -p /dist/usr/share/nginx/ /dist/reveal/
RUN node_modules/grunt/bin/grunt package --skipTests
RUN unzip reveal-js-presentation.zip -d /dist/reveal/
RUN ln -s /reveal /dist/usr/share/nginx/html

FROM nginx AS prod
COPY --from=aggregator --chown=nginx /dist /
EXPOSE 8080
ENTRYPOINT [ "/scripts/entrypoint.sh" ]