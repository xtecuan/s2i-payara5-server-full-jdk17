# quay.factory.promnet.com.sv:5000/spi/s2i-payara5-server-full-jdk17
FROM docker.io/payara/server-full:5.2022.5-jdk17

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Julian Rivera-Pineda <julian.rivera@promerica.com.sv>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

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
RUN apt-get update &&  apt-get -y install wget


# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
