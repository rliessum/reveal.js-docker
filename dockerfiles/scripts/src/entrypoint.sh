#!/bin/sh

WEB_FOLDER='/reveal/'
export RESOURCE_FOLDER='/resources'
export INPUT_INDEX_HTML_TEMPLATE="${WEB_FOLDER}/index.html"
export OUTPUT_INDEX_HTML="${WEB_FOLDER}/index.html"

echo "Templating index.html"
/scripts/templateIndexHtml

echo "Starting server"
exec "$@"