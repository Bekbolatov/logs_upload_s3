#!/bin/bash

cp -rf /work/cgi-bin /var/www/.
cp -rf /work/html /var/www/.
cp -rf /work/httpd.conf /etc/httpd/conf/.

chmod a+x /var/www/cgi-bin/*
chmod a+w -R /var/www/html


rm -rf /run/httpd/* /tmp/httpd*

#register with discovery service (mysql or zookeeper maybe)

exec /usr/sbin/apachectl -DFOREGROUND
