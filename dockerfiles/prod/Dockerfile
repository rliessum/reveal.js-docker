FROM node:11.15.0-alpine as node
FROM nginxinc/nginx-unprivileged:1.17.9-alpine as nginx

FROM node as aggregator 

RUN mkdir -p /tmp/cd-slides /dist/scripts /docs/
COPY . /tmp/cd-slides

# Speed up build by removing dependencies that are large and not needed for this use case
# qunit -> pupeteer -> chrome
WORKDIR /tmp/cd-slides
RUN sed -i '/^.*grunt-contrib-qunit.*$/d ; /^.*express.*$/d' package.json 
RUN npm install

COPY dockerfiles/scripts/src/* /dist/scripts/
COPY dockerfiles/prod/entrypoint.sh /dist/scripts
RUN mv /tmp/cd-slides/docs/slides /docs/slides

# Install envsubst to be used for index.html templating in final image
RUN apk add gettext # For envsubst -> if libaries are missing, find out with: ldd $(which envsubst)
RUN mkdir -p /dist/usr/bin/
RUN cp /usr/bin/envsubst /dist/usr/bin

# Package only whats necessary for static website 
RUN mkdir -p /dist/usr/share/nginx/html/docs/
RUN node_modules/grunt/bin/grunt package --skipTests
RUN unzip reveal-js-presentation.zip -d /dist/usr/share/nginx/html/
RUN ln -s /docs/slides /dist/usr/share/nginx/html/docs

FROM nginx AS prod
COPY --from=aggregator --chown=nginx /dist /
EXPOSE 8080
ENTRYPOINT [ "/scripts/entrypoint.sh" ]