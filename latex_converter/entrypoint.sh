#!/bin/bash

cp -rf /work/* /var/www/.

chmod a+x /var/www/cgi-bin/*
chmod a+w -R /var/www/html

rm -rf /run/httpd/* /tmp/httpd*

#register with discovery service (mysql or zookeeper maybe)

exec /usr/sbin/apachectl -DFOREGROUND
