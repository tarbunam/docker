# Base image for Atlassian software
# Debian Linux (jessie) with Oracle Java 8
#-----------------------------------------
FROM debian:jessie

MAINTAINER Michael Tarbunas <mike@tarbunas.net>

# Define build arguments
ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_MINOR=131
ARG JAVA_VERSION_BUILD=11
ARG JAVA_PACKAGE=jdk
ARG JAVA_HOME=/opt/jdk

# Preconfigure ENV
ENV JAVA_VERSION_MAJOR=$JAVA_VERSION_MAJOR \
    JAVA_VERSION_MINOR=$JAVA_VERSION_MINOR \
    JAVA_VERSION_BUILD=$JAVA_VERSION_BUILD \
    JAVA_PACKAGE=$JAVA_PACKAGE \
    JAVA_HOME=$JAVA_HOME \
    PATH=${PATH}:$JAVA_HOME/bin

# Pull in extras
ADD ["https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz", "/tmp/"]
ADD ["https://jdbc.postgresql.org/download/postgresql-42.1.1.jar", "/tmp/"]

RUN set -x && \
# Extract S6 overlay
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \

# Store Postgres JAR
    mkdir -p /opt/postgresql && \
    mv /tmp/postgresql-*.jar /opt/postgresql && \

# Install some dependencies
    echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update -q && \
    apt-get install -q -y --no-install-recommends curl unzip xmlstarlet ca-certificates && \
    apt-get install -t jessie-backports -q -y --no-install-recommends libtcnative-1 && \

# Install JDK
# shamelessly stolen from anapsix/alpine-java
    curl -jkSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/d54c1d3a095b4ff2b6607d096fa80163/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    gunzip /tmp/java.tar.gz && \
    tar -C /opt -xf /tmp/java.tar && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} && \
# Install unlimited JCE
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
      http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
    cd /tmp && unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
    cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar ${JAVA_HOME}/jre/lib/security && \
    sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/jre/lib/security/java.security && \

# Cleanup
    rm -rf ${JAVA_HOME}/*src.zip \
           ${JAVA_HOME}/lib/missioncontrol \
           ${JAVA_HOME}/lib/visualvm \
           ${JAVA_HOME}/lib/*javafx* \
           ${JAVA_HOME}/jre/plugin \
           ${JAVA_HOME}/jre/bin/javaws \
           ${JAVA_HOME}/jre/bin/jjs \
           ${JAVA_HOME}/jre/bin/orbd \
           ${JAVA_HOME}/jre/bin/pack200 \
           ${JAVA_HOME}/jre/bin/policytool \
           ${JAVA_HOME}/jre/bin/rmid \
           ${JAVA_HOME}/jre/bin/rmiregistry \
           ${JAVA_HOME}/jre/bin/servertool \
           ${JAVA_HOME}/jre/bin/tnameserv \
           ${JAVA_HOME}/jre/bin/unpack200 \
           ${JAVA_HOME}/jre/lib/javaws.jar \
           ${JAVA_HOME}/jre/lib/deploy* \
           ${JAVA_HOME}/jre/lib/desktop \
           ${JAVA_HOME}/jre/lib/*javafx* \
           ${JAVA_HOME}/jre/lib/*jfx* \
           ${JAVA_HOME}/jre/lib/amd64/libdecora_sse.so \
           ${JAVA_HOME}/jre/lib/amd64/libprism_*.so \
           ${JAVA_HOME}/jre/lib/amd64/libfxplugins.so \
           ${JAVA_HOME}/jre/lib/amd64/libglass.so \
           ${JAVA_HOME}/jre/lib/amd64/libgstreamer-lite.so \
           ${JAVA_HOME}/jre/lib/amd64/libjavafx*.so \
           ${JAVA_HOME}/jre/lib/amd64/libjfx*.so \
           ${JAVA_HOME}/jre/lib/ext/jfxrt.jar \
           ${JAVA_HOME}/jre/lib/ext/nashorn.jar \
           ${JAVA_HOME}/jre/lib/oblique-fonts \
           ${JAVA_HOME}/jre/lib/plugin.jar \
           /var/cache/apk/* && \

    apt-get autoremove --purge -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* \
           /var/tmp/* \
           /tmp/*
