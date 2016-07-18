FROM alpine:3.3
MAINTAINER Renat Bekbolatov <renatbek@gmail.com>

#RUN apk --update upgrade
#RUN apk add --no-cache nfs-utils
RUN mkdir /conf
ADD target/conf/ /conf/

CMD ["/bin/cp", "-rf", "/conf", "/EFS/."]
