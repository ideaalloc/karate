FROM ubuntu:xenial

MAINTAINER ideaalloc@gmail.com

ENV DEBIAN_FRONTEND noninteractive

##### update ubuntu and Install Python 3
RUN apt-get update \
  && apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev \
  && apt-get install -y curl net-tools build-essential software-properties-common libsqlite3-dev sqlite3 bzip2 libbz2-dev git wget unzip vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

#### Install Java 8
#### ---------------------------------------------------------------
#### ---- Change below when upgrading version ----
#### ---------------------------------------------------------------
ARG JAVA_MAJOR_VERSION=${JAVA_MAJOR_VERSION:-8}
ARG JAVA_UPDATE_VERSION=${JAVA_UPDATE_VERSION:-181}
ARG JAVA_BUILD_NUMBER=${JAVA_BUILD_NUMBER:-13}
ARG JAVA_DOWNLOAD_TOKEN=${JAVA_DOWNLOAD_TOKEN:-96a7b8442fe848ef90c96a2fad6ed6d1}
## http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz

#### ---------------------------------------------------------------
#### ---- Don't change below unless you know what you are doing ----
#### ---------------------------------------------------------------
ARG UPDATE_VERSION=${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}
ARG BUILD_VERSION=b${JAVA_BUILD_NUMBER}

ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV PATH $PATH:${JAVA_HOME}/bin
ENV INSTALL_DIR /usr

RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}-${BUILD_VERSION}/${JAVA_DOWNLOAD_TOKEN}/jdk-${UPDATE_VERSION}-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C $INSTALL_DIR/ \
  && ln -s ${JAVA_HOME} $INSTALL_DIR/java \
  && rm -rf ${JAVA_HOME}/man

#### Install Maven 3
ARG MAVEN_VERSION=${MAVEN_VERSION:-3.5.4}
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV MAVEN_HOME=/usr/apache-maven-${MAVEN_VERSION}
ENV PATH $PATH:${MAVEN_HOME}/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s ${MAVEN_HOME} /usr/maven

#### Install Golang
ENV GOROOT /usr/go
RUN curl -sL https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz \
  | gunzip \
  | tar x -C /usr/
ENV GOPATH /go
ENV PATH /usr/go/bin:/go/bin:/usr/bin:$PATH

#### Install MySQL
ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

## VERSIONS ##
RUN echo "JAVA_HOME=${JAVA_HOME}" && \
    java -version && \
    mvn --version && \
    go version && \
    mysql --version

#### define working directory.
RUN mkdir -p /data
COPY . /data

VOLUME "/data"

WORKDIR /data

# COPY pom.xml /tmp/pom.xml

# RUN mvn -B -f /tmp/pom.xml package -DskipTests

# RUN ["chmod", "+x", "/data/maven_runner.sh"]

# CMD ["/data/maven_runner.sh"]

#### Download stand-alone Karate
RUN curl -sL "https://s3-us-west-2.amazonaws.com/common-assets-api.atlasp.io/karate.jar" 2>/dev/null > karate.jar

RUN mkdir -p /usr/ka

RUN ["cp", "/data/karate.jar", "/usr/ka"]
RUN ["cp", "/data/karate.sh", "/usr/ka/karate"]
RUN ["cp", "/data/headers.js", "/usr/ka"]
RUN ["chmod", "+x", "/usr/ka/karate"]

ENV PATH $PATH:/usr/ka

#### Define default command.
ENTRYPOINT ["/bin/bash"]
