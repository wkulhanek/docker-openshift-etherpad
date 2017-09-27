#!/bin/bash
oc new-project etherpad --display-name "Shared Etherpad"
oc new-app mysql-persistent --param MYSQL_USER=ether --param MYSQL_PASSWORD=ether --param MYSQL_DATABASE=ether --param VOLUME_CAPACITY=4Gi --param MYSQL_VERSION=5.7
sleep 15
oc new-app wkulhanek/etherpad:latest -e DB_USER=ether -e DB_PASS=ether -e DB_DBID=ether -e DB_PORT=3306 -e DB_HOST=mysql
