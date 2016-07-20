#!/bin/bash

cp -rf /work/cgi-bin /var/www/.
cp -rf /work/html /var/www/.
cp -rf /work/httpd.conf /etc/httpd/conf/.

chmod a+x /var/www/cgi-bin/*
chmod a+w -R /var/www/html


rm -rf /run/httpd/* /tmp/httpd*

#register with discovery service (mysql or zookeeper maybe)
THIS_HOST=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
touch /EFS/run/services/latex2pdf/$THIS_HOST

exec /usr/sbin/apachectl -DFOREGROUND
