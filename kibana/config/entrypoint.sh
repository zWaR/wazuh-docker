#!/bin/bash
# Wazuh Docker Copyright (C) 2019 Wazuh Inc. (License GPLv2)

set -e

##############################################################################
# Waiting for elasticsearch
##############################################################################

if [ "x${CURL_PARAMETERS}" != "x" ] && [ "x${ELASTICSEARCH_URL}" != "x" ]; then
  el_url="${CURL_PARAMETERS} ${ELASTICSEARCH_URL}"
elif [ "x${ELASTICSEARCH_URL}" != "x" ]; then
  el_url="${ELASTICSEARCH_URL}"
else
  el_url="http://elasticsearch:9200"
fi

until curl -XGET $el_url; do
  >&2 echo "Elastic is unavailable - sleeping ${el_url}"
  sleep 5
done

sleep 2

>&2 echo "Elasticsearch is up."


##############################################################################
# Waiting for wazuh alerts template
##############################################################################

strlen=0


sleep 5

>&2 echo "Wazuh alerts template is loaded."


./wazuh_app_config.sh

sleep 5

./kibana_settings.sh &

/usr/local/bin/kibana-docker
