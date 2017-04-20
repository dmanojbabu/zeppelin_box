FROM centos:7

MAINTAINER Manoj

ENV ZEPPELIN_PORT 8080
ENV ZEPPELIN_HOME /usr/local/zeppelin
ENV PYTHON_HOME /usr/local/python
 
EXPOSE $ZEPPELIN_PORT

#install java
ENV JAVA_VERSION 8u31
ENV BUILD_VERSION b13

# Upgrading system
RUN yum -y upgrade
RUN yum -y install wget

# Downloading Java
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm

RUN yum -y install /tmp/jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV JAVA_HOME /usr/java/latest
 
#install other
RUN yum install -y \
  npm \
  vim \
  nano \
  curl \
  gcc \
  wget \
  make
 
#install Zeppelin
RUN wget ftp://apache.cs.utah.edu/apache.org/zeppelin/zeppelin-0.7.1/zeppelin-0.7.1-bin-all.tgz && \
  tar -zxf zeppelin-0.7.1-bin-all.tgz -C /usr/local/ && \
  mv /usr/local/zeppelin* $ZEPPELIN_HOME

RUN mkdir -p ${ZEPPELIN_HOME}/logs \
    && mkdir -p ${ZEPPELIN_HOME}/run \
    && mkdir -p ${ZEPPELIN_HOME}/notebook \
	&& mkdir -p ${ZEPPELIN_HOME}/data	

RUN yum install -y \
  readline-devel \
  sqlite-devel \
  zlib-devel \
  openssl-devel

#install python
RUN wget http://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz && \
  tar -zxf Python-3.6.1.tgz -C /usr/local/ && \
  mv /usr/local/Python* $PYTHON_HOME && \
  cd $PYTHON_HOME && \
  ./configure && \
  make altinstall 

  
WORKDIR $ZEPPELIN_HOME

VOLUME [${ZEPPELIN_HOME}/logs, ${ZEPPELIN_HOME}/notebook, ${ZEPPELIN_HOME}/data]

CMD ["/usr/local/zeppelin/bin/zeppelin.sh"]