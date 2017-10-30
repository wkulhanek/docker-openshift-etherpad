#!/bin/bash
oc new-project etherpad --display-name "Shared Etherpad"
oc new-app mysql-persistent --param MYSQL_USER=ether --param MYSQL_PASSWORD=ether --param MYSQL_DATABASE=ether --param VOLUME_CAPACITY=4Gi --param MYSQL_VERSION=5.7
sleep 15
oc new-app -f etherpad-template.yaml -p DB_USER=ether -p DB_PASS=ether -p DB_DBID=ether -p DB_PORT=3306 -p DB_HOST=mysql -p ADMIN_PASSWORD=secret
