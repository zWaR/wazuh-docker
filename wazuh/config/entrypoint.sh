#!/bin/bash

# Configuring and starting Wazuh-Manager, Wazuh-API and Filebeat
chkconfig --add wazuh-manager && service wazuh-manager start
sed -i 's|YOUR_ELASTIC_SERVER_IP|'elasticsearch'|g' /etc/filebeat/filebeat.yml
chkconfig --add filebeat && service filebeat start
/usr/bin/node /var/ossec/api/app.js > /dev/null 2>&1
