#!/bin/bash
oc new-project etherpad --display-name "Shared Etherpad"
oc new-app mysql-persistent --param MYSQL_USER=ether --param MYSQL_PASSWORD=ether --param MYSQL_DATABASE=ether --param VOLUME_CAPACITY=4Gi --param MYSQL_VERSION=5.7
# Root Pwd: PfhiJw8Tmq55ju0d
# DB Service Name: mysql
# Connection URL: mysql://mysql:3306/
