#!/bin/sh

SKIP_TEMPLATING=${SKIP_TEMPLATING:-''}
WEB_FOLDER='/reveal/'
export RESOURCE_FOLDER='/resources'
export INPUT_INDEX_HTML_TEMPLATE="${WEB_FOLDER}/index.html"
export OUTPUT_INDEX_HTML="${WEB_FOLDER}/index.html"

if [ -z "${SKIP_TEMPLATING}" ]; then
    echo "Templating index.html"
    /scripts/templateIndexHtml
else
    echo "Skipping templating, because env var SKIP_TEMPLATING is set"
fi

echo "Starting server"
exec "$@"