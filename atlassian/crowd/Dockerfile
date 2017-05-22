# Atlassian Crowd
#-----------------------------------------
FROM tarbunam/atlassian-base

MAINTAINER Michael Tarbunas <mike@tarbunas.net>

# Build args
ARG APP_NAME=crowd
ARG APP_LONG_NAME=$APP_NAME
ARG APP_VERSION=2.12.0
ARG SERVICE_USER=$APP_NAME
ARG SERVICE_GROUP=$APP_NAME
ARG APP_HOME=/var/atlassian/crowd
ARG APP_INSTALL=/opt/atlassian/crowd
ARG APP_INSTALL_LIB="${APP_INSTALL}/apache-tomcat/lib"
ARG APP_INSTALL_BIN="${APP_INSTALL}/apache-tomcat/bin"
ARG APP_PROPS_FILE="${APP_INSTALL}/crowd-webapp/WEB-INF/classes/crowd-init.properties"

# Export things of interest
VOLUME [/var/atlassian/crowd]
EXPOSE 8095/tcp

# Preconfigure ENV
ENV APP_NAME=$APP_NAME \
    APP_HOME=$APP_HOME \
    APP_INSTALL=$APP_INSTALL \
    APP_VERSION=$APP_VERSION \
    SERVICE_USER=$SERVICE_USER \
    SERVICE_GROUP=$SERVICE_GROUP \
    SERVICE_INIT="${APP_INSTALL_BIN}/catalina.sh"

RUN set -x && \
# Create user and group
    groupadd $SERVICE_GROUP && \
    useradd -d "${APP_HOME}" -s /bin/false -g $SERVICE_GROUP $SERVICE_USER && \

# Create directories
    mkdir -p "${APP_HOME}" && \
    mkdir -p "${APP_INSTALL}" && \

# Fetch and install
    curl -sSL -o /tmp/atlassian-installer.tar.gz \
        "https://downloads.atlassian.com/software/${APP_NAME}/downloads/atlassian-${APP_LONG_NAME}-${APP_VERSION}.tar.gz" && \
    tar -xz -C "${APP_INSTALL}" --strip-components=1 --no-same-owner -f /tmp/atlassian-installer.tar.gz && \

# Pull in Postgres driver
    rm "${APP_INSTALL_LIB}"/postgresql* && \
    mv /opt/postgresql/postgresql-*.jar "${APP_INSTALL_LIB}/" && \

# Update ownership
    chmod -R 700 "${APP_HOME}" && \
    chmod -R 700 "${APP_INSTALL}" && \
    chown -R $SERVICE_USER:$SERVICE_GROUP "${APP_HOME}" && \
    chown -R $SERVICE_USER:$SERVICE_GROUP "${APP_INSTALL}" && \

# Configure
    printf "\n${APP_NAME}.home=${APP_HOME}\n" >> "${APP_PROPS_FILE}" && \

# Cleanup
    apt-get autoremove --purge -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* \
           /var/tmp/* \
           /tmp/*

# Finalize setup
ENV HOME=${APP_HOME}
COPY "docker-entrypoint.sh" "/docker-entrypoint.sh"
COPY "fix-attrs.sh" "/etc/fix-attrs.d/01-data-dirs"

# Set entrypoint
ENTRYPOINT ["/init"]
CMD ["/docker-entrypoint.sh"]
