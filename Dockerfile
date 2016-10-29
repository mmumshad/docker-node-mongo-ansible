# Pull base image.
FROM library/ubuntu

MAINTAINER Mumshad Mannambeth <mmumshad@gmail.com>

RUN apt-get update

#
# Python
#
RUN apt-get install -y python python-dev python-pip python-virtualenv


#
# Node.js and NPM
#
RUN apt-get install -y nodejs nodejs-legacy npm git --no-install-recommends
RUN ln -s /dev/null /dev/raw1394

#
# Grunt, Bower, Forever
#
RUN npm install grunt -g
RUN npm install bower -g
RUN npm install forever -g

#
# Mongo
#

ENV MONGO_MAJOR 3.2
ENV MONGO_VERSION 3.2.10

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

RUN set -x \
        && apt-get update \
        && apt-get install -y \
                mongodb-org=$MONGO_VERSION \
                mongodb-org-server=$MONGO_VERSION \
                mongodb-org-shell=$MONGO_VERSION \
                mongodb-org-mongos=$MONGO_VERSION \
                mongodb-org-tools=$MONGO_VERSION \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/lib/mongodb \
        && mv /etc/mongod.conf /etc/mongod.conf.orig

RUN mkdir -p /data/db /data/configdb \
        && chown -R mongodb:mongodb /data/db /data/configdb
VOLUME /data/db /data/configdb

EXPOSE 27017

#
# Ansible
#

RUN apt-get update && apt-get -y install software-properties-common && add-apt-repository ppa:ansible/ansible && apt-get update && apt-get -y install ansible
