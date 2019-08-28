#!/bin/bash

# It will run every .sh script located in entrypoint-scripts folder in lexicographical order
for script in `ls /entrypoint-scripts/*.sh | sort -n`; do
  bash "$script"

done

# Configuring and starting Wazuh-Manager, Wazuh-API and Filebeat
chkconfig --add wazuh-manager && service wazuh-manager start
chkconfig --add filebeat && service filebeat start
/usr/bin/node /var/ossec/api/app.js > /dev/null 2>&1
