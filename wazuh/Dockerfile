FROM centos:7

ARG FILEBEAT_VERSION=7.1.1
ARG WAZUH_VERSION=3.9.4-1
ARG TEMPLATE_VERSION="v3.9.4"
ARG WAZUH_FILEBEAT_MODULE="wazuh-filebeat-0.1.tar.gz"

ENV API_USER="foo" \
   API_PASS="bar"
   
# Required to ensure service works properly
RUN yum -y install initscripts && yum clean all

# Set repositories.
RUN rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH

RUN echo $'[wazuh_repo]\n\
gpgcheck=1\n\
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH\n\
enabled=1\n\
name=Wazuh repository\n\
baseurl=https://packages.wazuh.com/3.x/yum/\n\
protect=1\n'\
>> /etc/yum.repos.d/wazuh.repo

RUN yum --enablerepo=updates clean metadata && \
  yum -y update && yum -y install openssl && yum -y install wazuh-manager-${WAZUH_VERSION} -y && \
  curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
  yum -y install nodejs && yum -y install wazuh-api-${WAZUH_VERSION} && \
  sed -i "s/^enabled=1/enabled=0/" /etc/yum.repos.d/wazuh.repo

RUN echo openssl_conf = openssl_conf_section > /etc/pki/tls/openssl.cnf && \
echo [openssl_conf_section] >> /etc/pki/tls/openssl.cnf && \
echo alg_section = evp_settings >> /etc/pki/tls/openssl.cnf && \
echo [evp_settings] >> /etc/pki/tls/openssl.cnf && \
echo fips_mode = yes >> /etc/pki/tls/openssl.cnf

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-${FILEBEAT_VERSION}-x86_64.rpm &&\
  rpm -i filebeat-oss-${FILEBEAT_VERSION}-x86_64.rpm && rm -f filebeat-oss-${FILEBEAT_VERSION}-x86_64.rpm

RUN curl -so /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/wazuh/wazuh/${TEMPLATE_VERSION}/extensions/filebeat/7.x/filebeat.yml &&\
  chmod go+r /etc/filebeat/filebeat.yml

RUN curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/${TEMPLATE_VERSION}/extensions/elasticsearch/7.x/wazuh-template.json &&\
  chmod go+r /etc/filebeat/wazuh-template.json

RUN curl -s https://packages.wazuh.com/3.x/filebeat/${WAZUH_FILEBEAT_MODULE} | tar -xvz -C /usr/share/filebeat/module

# Setting volumes
VOLUME ["/var/ossec/data"]
VOLUME ["/etc/filebeat"]
VOLUME ["/var/lib/filebeat"]

# Services ports
EXPOSE 55000/tcp 1514/udp 1515/tcp 514/udp 1516/tcp

# Copy filebeat.yml
COPY config/filebeat.yml /etc/filebeat/

# Setting up and running entrypoint scripts
RUN mkdir /entrypoint-scripts

COPY config/entrypoint.sh /entrypoint.sh
COPY config/01-config_filebeat.sh /entrypoint-scripts/01-config_filebeat.sh

RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]