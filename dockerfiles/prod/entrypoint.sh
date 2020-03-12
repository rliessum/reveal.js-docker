#!/bin/sh

WEB_FOLDER='/usr/share/nginx/html/'
export RESOURCE_FOLDER='/resources'
export INPUT_INDEX_HTML_TEMPLATE="${WEB_FOLDER}/index.html"
export OUTPUT_INDEX_HTML="${WEB_FOLDER}/index.html"

echo "Templating index.html"
/scripts/templateIndexHtml

echo "Serving static website"
exec nginx -g 'daemon off;'