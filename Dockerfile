# quay.factory.promnet.com.sv:5000/spi/s2i-payara5-server-full-jdk17
FROM docker.io/payara/server-full:5.2022.5-jdk17

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Julian Rivera-Pineda <julian.rivera@promerica.com.sv>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0
ENV MAVEN_BINARY_URL https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.zip
ENV MAVEN_ZIP_LOCAL /opt/payara/apache-maven-3.8.8-bin.zip
ENV MAVEN_HOME /opt/payara/maven388
ENV PATH "${PATH}:${MAVEN_HOME}/bin"
ENV APP_SOURCE "/opt/payara/src"

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Jakarta EE Applications using Payara5 Server Full jdk17" \
      io.k8s.display-name="builder Payara5-Server-Full-jdk17" \
      io.openshift.expose-services="8080:http,8181:https" \
      io.openshift.tags="builder,Payara5-Server-Full-jdk17,Java,JakartaEE"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
#RUN yum install -y rubygems && yum clean all -y
#RUN gem install asdf
USER root
COPY files/sources.list.txt /etc/apt/sources.list
RUN apt-get update &&  apt-get -y install wget curl zip unzip git
RUN wget -O $MAVEN_ZIP_LOCAL $MAVEN_BINARY_URL && unzip $MAVEN_ZIP_LOCAL -d /opt/payara/
RUN ln -s /opt/payara/apache-maven-3.8.8 /opt/payara/maven388
RUN chown -R 1000 /opt/payara/apache-maven-3.8.8 /opt/payara/maven388
RUN rm $MAVEN_ZIP_LOCAL
RUN mkdir -p $APP_SOURCE && chown -R 1000 $APP_SOURCE

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1000
RUN echo $JAVA_HOME && echo $MAVEN_HOME && echo $PATH
RUN mvn -version
# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
