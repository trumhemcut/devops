FROM gitlab/gitlab-ce:latest
MAINTAINER Phi Huynh <phi.huynh@nashtechglobal.com>

COPY ./gitlab.rb /etc/gitlab/gitlab.rb

RUN apt-get -y update && apt-get -y install ldap-utils && apt-get -y install iputils-ping