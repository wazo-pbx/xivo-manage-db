Dockerfile for XiVO xivo-manage-db

## Install Docker

To install docker on Linux :

    curl -sL https://get.docker.io/ | sh
 
 or
 
     wget -qO- https://get.docker.io/ | sh

## Build

To build the image, simply invoke

    docker build -t xivo-manage-db github.com/xivo-pbx/xivo-manage-db

Or directly in the sources in contribs/docker

    docker build -t xivo-manage-db .
  
## Usage

To run the container, do the following:

    docker run -d -v manage-db/conf.d:/etc/xivo-dao/conf.d/ -v manage-db/alembic.ini:/usr/share/xivo-manage-db/alembic.ini --volumes-from=db xivo-manage-db

On interactive mode :

    docker run -v manage-db/conf.d:/etc/xivo-dao/conf.d/ -v manage-db/alembic.ini:/usr/share/xivo-manage-db/alembic.ini --volumes-from=db -it xivo-manage-db bash

After launch xivo-init-db.

    xivo-init-db --init

## Infos

- Using docker version 1.5.0 (from get.docker.io) on ubuntu 14.04.
- If you want to using a simple webi to administrate docker use : https://github.com/crosbymichael/dockerui

To get the IP of your container use :

    docker ps -a
    docker inspect <container_id> | grep IPAddress | awk -F\" '{print $4}'